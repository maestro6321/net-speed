pragma ComponentBehavior: Bound

import QtQuick
import Ryoku.PluginKit.Singletons

Item {
    id: root

    property var pluginApi
    property var screen
    property bool active: false
    property string density: "glyph"
    property real s: 1
    property real widthBudget: 0
    property bool open: false
    property real reveal: 0
    property bool tabActive: false

    signal requestClose()

    readonly property var service:
        pluginApi ? pluginApi.mainInstance : null

    implicitWidth: row.implicitWidth
    implicitHeight: Math.max(row.implicitHeight, 22 * root.s)

    Row {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 9 * root.s

        Row {
            spacing: 3 * root.s
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "↓"
                color: "#55D68B"
                font.pixelSize: 15 * root.s
                font.bold: true
            }

            Text {
                text: root.service
                    ? root.service.downloadText : "--"
                color: Theme.bright
                font.family: Theme.mono
                font.pixelSize: 12 * root.s

                width: 60 * root.s
                horizontalAlignment: Text.AlignRight
            }
        }

        Row {
            spacing: 3 * root.s
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "↑"
                color: "#62A9FF"
                font.pixelSize: 15 * root.s
                font.bold: true
            }

            Text {
                text: root.service
                    ? root.service.uploadText : "--"
                color: Theme.bright
                font.family: Theme.mono
                font.pixelSize: 12 * root.s

                width: 60 * root.s
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            if (root.pluginApi)
                root.pluginApi.togglePanel()
        }
    }
}