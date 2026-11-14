pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

Item {
    id: svc

    property var pluginApi

    readonly property var settings:
        pluginApi ? pluginApi.pluginSettings : null

    readonly property string interfaceName:
        settings && settings.interface
        ? String(settings.interface).trim()
        : "wlan0"

    property real downloadBytesPerSecond: 0
    property real uploadBytesPerSecond: 0

    property double previousRx: -1
    property double previousTx: -1
    property double lastSampleTime: 0
    property string previousInterface: ""

    property string statusText: "Initializing"

    readonly property string downloadText:
        formatRate(downloadBytesPerSecond)

    readonly property string uploadText:
        formatRate(uploadBytesPerSecond)

    function formatRate(value) {
        if (value >= 1000000)
            return (value / 1000000).toFixed(2) + " MB/s";

        if (value >= 1000)
            return (value / 1000).toFixed(1) + " KB/s";

        return Math.round(value) + " B/s";
    }

    function consumeNetworkData(contents) {
        const iface = svc.interfaceName;

        if (!iface) {
            statusText = "No interface selected";
            return;
        }

        const lines = contents.split("\n");

        for (let i = 0; i < lines.length; i++) {
            const match = lines[i].match(/^\s*([^:]+):\s*(.*)$/);

            if (!match || match[1].trim() !== iface)
                continue;

            const values = match[2].trim().split(/\s+/);

            if (values.length < 9)
                break;

            const rx = Number(values[0]);
            const tx = Number(values[8]);

            if (isNaN(rx) || isNaN(tx))
                break;

            const now = Date.now();

            if (svc.previousInterface !== iface ||
                svc.previousRx < 0 ||
                svc.previousTx < 0) {

                svc.previousRx = rx;
                svc.previousTx = tx;
                svc.previousInterface = iface;
                svc.lastSampleTime = now;

                svc.downloadBytesPerSecond = 0;
                svc.uploadBytesPerSecond = 0;
                svc.statusText = "Monitoring";

                return;
            }

            const elapsed = (now - svc.lastSampleTime) / 1000;

            if (elapsed > 0) {
                svc.downloadBytesPerSecond =
                    Math.max(0, rx - svc.previousRx) / elapsed;

                svc.uploadBytesPerSecond =
                    Math.max(0, tx - svc.previousTx) / elapsed;
            }

            svc.previousRx = rx;
            svc.previousTx = tx;
            svc.lastSampleTime = now;
            svc.statusText = "Connected";

            return;
        }

        svc.previousRx = -1;
        svc.previousTx = -1;
        svc.previousInterface = "";

        svc.downloadBytesPerSecond = 0;
        svc.uploadBytesPerSecond = 0;
        svc.statusText = "Interface unavailable";
    }

    FileView {
        id: networkFile

        path: "/proc/net/dev"
        printErrors: false

        onLoaded: svc.consumeNetworkData(networkFile.text())
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: networkFile.reload()
    }
}