import QtQuick 2.0
import QtQuick.Controls 2.13

RoundButton { id: kreuz; height: 40; width: 40;
            anchors.top: rect.top; anchors.topMargin: 10
            anchors.right: rect.right; anchors.rightMargin: 10

            Text {
                id: kreuz_text
                text: "x"
                color: "black"
                font.family: "Helvetica"
                font.pointSize: 16
                font.bold: true
                anchors.horizontalCenter: kreuz.horizontalCenter
                anchors.verticalCenter: kreuz.verticalCenter
            }
}
