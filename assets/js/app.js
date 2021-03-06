// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import {Socket, Presence} from "phoenix"
import Vue from "vue"
import ExChatApp from "../components/ex-chat-app.vue"
import OnlineUsers from "../components/online-users.vue"
import RoomNav from "../components/room-nav.vue"
import ChatWindow from "../components/chat-window.vue"

var elem = document.getElementById("app")
if (elem != null) {
    Vue.component('ex-chat-app', ExChatApp)
    Vue.component('online-users', OnlineUsers)
    Vue.component('room-nav', RoomNav)
    Vue.component('chat-window', ChatWindow)

    new Vue({
        el: '#app',
        render(createElement) {
            return createElement(ExChatApp, {})
        }
    })
}
