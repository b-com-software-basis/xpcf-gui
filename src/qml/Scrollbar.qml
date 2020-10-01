import QtQuick 2.3

Item {
    id: scrollBar
    //width: (handleSize + 2 * (backScrollbar.border.width +1))/2;
    height: flickable.height
    width:10

    anchors {
        top: flickable.top;
        right: flickable.right;
        bottom: flickable.bottom;
       // margins: 1;
    }

    property Flickable flickable               : null;


    property int       handleSize              : 20;

    function scrollDown () {
        flickable.contentY = Math.min (flickable.contentY + (flickable.height / 4), flickable.contentHeight - flickable.height);
        console.log(Math.min (flickable.contentY + (flickable.height / 4), flickable.contentHeight - flickable.height));

    }
    function scrollUp () {
        flickable.contentY = Math.max (flickable.contentY - (flickable.height / 4), 0);
        console.log(Math.max (flickable.contentY - (flickable.height / 4), 0));
    }
    Binding {
            target: handle;
            property: "y";
            value: (flickable.contentY * clicker.drag.maximumY / (flickable.contentHeight - flickable.height));
            when: (!clicker.drag.active);
        }

   Binding {
        target: flickable;
        property: "contentY";
        value: (handle.y * (flickable.contentHeight - flickable.height) / clicker.drag.maximumY);
        when: (clicker.drag.active || clicker.pressed);
    }

    Rectangle {
        id: backScrollbar;
        radius: 1;
        antialiasing: true;
        color: "black";
        border {
            width: 1;
            color: "transparent";
        }
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 2

        MouseArea {
            anchors.fill: parent;
            onClicked: { }
        }
    }
    MouseArea {
        id: btnUp;
        height: width;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            margins: (backScrollbar.border.width +1);
        }
        onClicked: { scrollUp (); }

        Text {
            text: "";
            color: (btnUp.pressed ? "white" : "white");
            rotation: -180;
            anchors.centerIn: parent;
        }
    }
    MouseArea {
        id: btnDown;
        height: width;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            margins: (backScrollbar.border.width +1);
        }
        onClicked: { scrollDown (); }

        Text {
            text: "";
            color: (btnDown.pressed ? "white" : "white");
            anchors.centerIn: parent;
        }
    }

    Item {
        id: groove;
        clip: true;
        anchors {
            fill: parent;
            topMargin: (backScrollbar.border.width +1 + btnUp.height +1);
            leftMargin: (backScrollbar.border.width +1);
            rightMargin: (backScrollbar.border.width +1);
            bottomMargin: (backScrollbar.border.width +1 + btnDown.height +1);
        }

        MouseArea {
            id: clicker;
            drag {
                target: handle;
                minimumY: 0;
                maximumY: (groove.height - handle.height);
                axis: Drag.YAxis;
            }
            anchors { fill: parent; }
            onClicked: { flickable.contentY = (mouse.y / groove.height * (flickable.contentHeight - flickable.height)); }
        }
        Item {
            id: handle;
         //   height: Math.max (10, (flickable.visibleArea.heightRatio * groove.height));
            height:50
            anchors {
                left: parent.left;
                right: parent.right;
            }

            Rectangle {
                id: backHandle;
                color: (clicker.pressed ? "white" : "white");
                anchors { fill: parent; }

                Behavior on opacity { NumberAnimation { duration: 150; } }
            }
        }
    }
}
