import QtQuick 2.0
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.12

Rectangle{
    id: menu
    width: 400
    height: 640
    anchors{
        right: parent.right
        top: parent.top
    }
    color: "transparent"
ComboBox{
    anchors{
        right: menu.right
        rightMargin: 5
        top: menu.top
        topMargin: 5

    }
        currentIndex: 1
        width: 40
        height: 30
        id: main_menu
        model: ListModel{
            ListElement {text:"S"}
            ListElement {text:"M"}
            ListElement {text:"I"}

    }
        onCurrentTextChanged: {
            changePage()
        }

        function changePage(){
            switch (main_menu.currentText) {
                case "S":
                    mainStack.pop(null); uiStack.pop(null); menuLoad.source=""; main_menu.incrementCurrentIndex();
                    console.log(main_menu.currentText);
                    break;
                case "M":
                    mainStack.pop();
                    console.log(main_menu.currentText); uiStack.pop();
                    break;
                case "I":
                    mainStack.push("./import.qml"); uiStack.push("../pagesStackView/impButtons.qml")
                    console.log(main_menu.currentText);
                    break;
        }
    }

}

}
