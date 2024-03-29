/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Sharing 0.1
import Qt.labs.gestures 2.0


Item {
    id: container
    height: childrenRect.height

    // View Modes:
    // 0 - single photo view toolbar
    // 1 - grid view toolbar
    // 2 - grid view toolbar with cancel multiple select
    property int mode: 2

    property bool isFavorite: true
    property alias sharing: shareIcon

    signal play()
    signal prev()
    signal next()
    signal favorite()
    signal rotateLeft()
    signal rotateRight()
    signal cancel()
    signal deleteSelected()
    signal addToAlbum()

    // block all gestures from falling through
    GestureArea {
        anchors.fill: parent

        Tap {}
        TapAndHold {}
        Pan {}
        Swipe {}
        Pinch {}
    }

    BorderImage {
        anchors.fill: parent
        source: "image://theme/media/nextbox_landscape"
        border.top: 10
        border.bottom:10
        border.left: 10
        border.right: 10
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        IconButton {
            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://meegotheme/icons/toolbar/go-back-active"
            iconDown: "image://meegotheme/icons/toolbar/go-back"
            hasBackground: false
            onClicked: container.prev()
        }
        IconButton {
            opacity: mode == 0 || mode == 1 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://theme/icn_play_up"
            iconDown: "image://theme/icn_play_dn"
            hasBackground: false
            onClicked: container.play()
        }
        IconButton {
            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://meegotheme/icons/toolbar/go-forward-active"
            iconDown: "image://meegotheme/icons/toolbar/go-forward"
            hasBackground: false
            onClicked: container.next()
        }
    }
    Row {
        id: mode2Buttons
        anchors.left: parent.left
        width: parent.width
        height: container.height -10
        anchors.verticalCenter: parent.verticalCenter
        spacing: (width - 400)/3
        visible: mode == 2
        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://theme/media/icn_trash_up"
            iconDown: "image://theme/media/icn_trash_dn"
            hasBackground: false
            onClicked: container.deleteSelected()
        }
        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://theme/media/icn_addtoalbum_up"
            iconDown: "image://theme/media/icn_addtoalbum_dn"
            hasBackground: false
            onClicked: container.addToAlbum()
        }
        Labs.ShareIcon {
            id: shareIcon
        }
        IconButton {
            icon: "image://theme/media/icn_cancel_ms_up"
            iconDown: "image://theme/media/icn_cancel_ms_dn"
            hasBackground: false
            onClicked: container.cancel()
        }
    }

    IconButton {
        opacity: mode == 0 ? 1.0 : 0.0
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        icon: "image://theme/media/icn_rotate_cw_up"
        iconDown: "image://theme/media/icn_rotate_cw_dn"
        hasBackground: false
        onClicked: container.rotateRight()
    }
    IconButton {
        opacity: mode == 0 ? 1.0 : 0.0
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        icon: container.isFavorite ? "image://theme/media/icn_favourite_active" : "image://theme/media/icn_favourite_up"
        iconDown: "image://theme/media/icn_favourite_dn"
        hasBackground: false
        onClicked: {
            container.isFavorite = !container.isFavorite;
            container.favorite();
        }
    }

    states: [
        State {
            name: "multisel"
            when: mode == 2
        },
        State {
            name: "normal"
            when: mode != 2
        }
    ]

    transitions: [
        Transition {
            from: "normal"
            to: "multisel"
            ScriptAction {
                script: sharing.clearItems();
            }
        }
    ]
}

