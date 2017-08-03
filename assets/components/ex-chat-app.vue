<template>
    <div class="columns">
        <aside class="column is-2 hero is-dark is-fullheight is-hidden-mobile aside">
            <div class="main">
                <!-- TODO: User -->
                <room-nav :rooms="rooms" :initial-room="initialRoom" v-model="currentChannel"></room-nav>
                <online-users :presences="presences" :current-channel="currentChannel"></online-users>
            </div>
        </aside>
        <div class="column no-padding">
            <div class="chat-container">
                <div class="columns">
                    <div class="column is-10">
                        <h1 class="title">#{{ currentChannel }}</h1>
                    </div>
                    <div class="column">Users in this room: {{ users_online }}</div>
                </div>
                <hr>
                <div class="ex-chat-app">
                    <chat-window :current-channel="currentChannel" :messages="messages"></chat-window>
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
            initialRoom: "lobby",
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
    },
    computed: {
        users_online: function() {
            var size = 0
            for(var key in this.presences[this.currentChannel]) {
                if (this.presences[this.currentChannel].hasOwnProperty(key)) size++
            }
            return size
        }
    }
}
</script>

<style>
</style>
