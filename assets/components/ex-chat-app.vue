<template>
    <div class="columns">
        <aside class="column is-2 hero is-dark is-fullheight is-hidden-mobile aside">
            <div class="main">
                <!-- TODO: User -->
                <nav class="menu">
                    <p class="menu-label">Channels</p>
                    <ul class="menu-list">
                        <li><a class="is-active">#lobby</a></li>
                    </ul>
                </nav>
                <online-users :presences="presences"></online-users>
            </div>
        </aside>
        <div class="column no-padding">
            <div class="chat-container">
                <h1 class="title">#lobby</h1>
                <hr>
                <div class="ex-chat-app">
                    <div class="chat-messages">
                        <div class="msg-container" v-for="message in messages">
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

export default {
    props: ['jwt'],
    data() {
        return {
            socket: null,
            channel: null,
            message: "",
            messages: [],
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
            this.channel.push("new_msg", { body: this.message })
            this.message = ""
        },

        connectToChat() {
            this.socket = new Socket("/socket", {params: { guardian_token: this.token }})
            this.socket.connect()

            this.channel = this.socket.channel("room:lobby", {})
            this.channel.on("new_msg", payload => {
                payload.received_at = Date()
                payload.time = new Date(payload.time)
                this.messages.push(payload)
            })

            this.channel.on("presence_state", state => {
                this.presences = Presence.syncState(this.presences, state)
            })
            this.channel.on("presence_diff", diff => {
                this.presences = Presence.syncDiff(this.presences, diff)
            })

            this.channel.join()
                .receive("ok", response => {
                    this.messages = []
                    console.log("Joined successfully", response)
                })
                .receive("error", response => { console.log("Unable to join", response) })
        },
    },
}
</script>

<style>
</style>
