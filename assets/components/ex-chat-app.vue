<template>
    <div class="columns">
        <aside class="column is-2 hero is-dark is-fullheight is-hidden-mobile aside">
            <div class="main">
                <!-- TODO: User -->
                <nav class="menu">
                    <p class="menu-label">Channels</p>
                    <ul class="menu-list">
                        <li v-for="room in rooms">
                            <a v-bind:class="isCurrentRoom(room)" v-on:click="currentChannel = room">#{{ room }}</a>
                        </li>
                    </ul>
                </nav>
                <online-users :presences="presences" :current-channel="currentChannel"></online-users>
            </div>
        </aside>
        <div class="column no-padding">
            <div class="chat-container">
                <h1 class="title">#{{ currentChannel }}</h1>
                <hr>
                <div class="ex-chat-app">
                    <div class="chat-messages">
                        <div class="msg-container" v-for="message in messages[currentChannel]">
                            <div class="media">
                                <figure class="media-left">
                                    <p class="image is-48x48">
                                        <img src="http://bulma.io/images/placeholders/128x128.png">
                                    </p>
                                </figure>
                                <div class="media-content">
                                    <div class="content chat-content">
                                        <p><strong>{{ message.username }}</strong> <small>{{ message.time.toLocaleTimeString() }}</small>
                                        <br>{{ message.body }}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="field has-addons is-fullwidth">
                        <div class="control is-expanded">
                            <input class="input" type="text" placeholder="Your Message" v-model="message" v-on:keyup.13="sendMessage">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import {Socket, Presence} from "phoenix"
import Vue from "vue"

export default {
    props: ['jwt'],
    data() {
        return {
            socket: null,
            channels: {},
            currentChannel: "",
            message: "",
            rooms: ["lobby", "test"],
            messages: {},
            presences: {},
            token: ""
        }
    },
    mounted() {
        this.token = window.jwt
        this.connectToChat()
    },
    updated() {
        var chat = this.$el.querySelector("div.chat-messages")
        chat.scrollTop = chat.scrollHeight
    },
    render(createElement) {
        return createElement(ExChatApp, {})
    },
    methods: {
        sendMessage() {
            this.channels[this.currentChannel].push("new_msg", { body: this.message })
            this.message = ""
        },

        connectToChat() {
            this.socket = new Socket("/socket", {params: { guardian_token: this.token }})
            this.socket.connect()

            for (var id in this.rooms)
                this.joinRoom(this.rooms[id])
            this.currentChannel = "lobby"
        },

        joinRoom(room) {
            Vue.set(this.messages, room, [])
            Vue.set(this.presences, room, {})

            this.channels[room] = this.socket.channel("room:" + room, {})
            this.channels[room].on("new_msg", payload => {
                payload.received_at = Date()
                payload.time = new Date(payload.time)
                this.messages[room].push(payload)
            })

            this.channels[room].on("presence_state", state => {
                this.presences[room] = Presence.syncState(this.presences[room], state)
            })
            this.channels[room].on("presence_diff", diff => {
                this.presences[room] = Presence.syncDiff(this.presences[room], diff)
            })

            this.channels[room].join()
                .receive("ok", response => {
                    Vue.set(this.messages, room, [])
                    console.log("Joined successfully", response)
                })
                .receive("error", response => { console.log("Unable to join", response) })
        },

        isCurrentRoom: function(room) {
            if (this.currentChannel == room) {
                return "is-active"
            }
            return ""
        }
    }
}
</script>

<style>
</style>
