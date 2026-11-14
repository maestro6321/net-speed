import QtQuick
import Ryoku.PluginKit.Singletons

Item {
    id: root

    property var pluginApi
    property string density: "full"
    property real s: 1
    property real widthBudget: 320
    property bool active: false

    readonly property var service:
        pluginApi ? pluginApi.mainInstance : null

    implicitWidth: root.widthBudget
    implicitHeight: col.implicitHeight + 28 * root.s

    Column {
        id: col

        x: 14 * root.s
        y: 14 * root.s
        width: root.width - 28 * root.s
        spacing: 14 * root.s

        Text {
            text: "Internet Monitor"
            color: Theme.bright
            font.family: Theme.display
            font.pixelSize: 18 * root.s
        }

        Text {
            text: serviceStatus
            color: Theme.dim
            font.family: Theme.font
            font.pixelSize: 12 * root.s
        }

        Row {
            width: parent.width
            spacing: 10 * root.s

            Rectangle {
                width: (parent.width - 10 * root.s) / 2
                height: 85 * root.s
                radius: Theme.radius
                color: Theme.card

                Column {
                    anchors.centerIn: parent
                    spacing: 5 * root.s

                    Text {
                        text: "↓ DOWNLOAD"
                        color: "#55D68B"
                        font.pixelSize: 11 * root.s
                    }

                    Text {
                        text: root.service
                            ? root.service.downloadText : "--"
                        color: Theme.bright
                        font.family: Theme.mono
                        font.pixelSize: 17 * root.s
                    }
                }
            }

            Rectangle {
                width: (parent.width - 10 * root.s) / 2
                height: 85 * root.s
                radius: Theme.radius
                color: Theme.card

                Column {
                    anchors.centerIn: parent
                    spacing: 5 * root.s

                    Text {
                        text: "↑ UPLOAD"
                        color: "#62A9FF"
                        font.pixelSize: 11 * root.s
                    }

                    Text {
                        text: root.service
                            ? root.service.uploadText : "--"
                        color: Theme.bright
                        font.family: Theme.mono
                        font.pixelSize: 17 * root.s
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.dim
            opacity: 0.25
        }

        Row {
            width: parent.width
            spacing: 5

            Text {
                text: "Interface:"
                color: Theme.dim
                font.pixelSize: 12 * root.s
            }

            Text {
                text: root.service
                    ? root.service.interfaceName : "--"
                color: Theme.bright
                font.pixelSize: 12 * root.s
            }
        }
    }

    readonly property string serviceStatus:
        root.service ? root.service.statusText : "Starting..."
}