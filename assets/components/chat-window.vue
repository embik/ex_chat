<template>
    <div class="chat-messages" v-on:scroll="requestOlderMessages">
        <div class="content has-text-centered has-text-grey-light" style="margin-top: 48px;">
            <small v-if="noNewMessages[currentChannel]">No new messages for this room available!</small>
            <small v-else>Scroll to load older messages ...</small>
        </div>
        <div class="msg-container" v-for="message in messages[currentChannel]">
            <div class="media">
                <figure class="media-left">
                    <p class="image is-48x48">
                        <img src="http://bulma.io/images/placeholders/128x128.png">
                    </p>
                </figure>
                <div class="media-content">
                    <div class="content chat-content">
                        <p>
                            <strong>{{ message.username }}</strong> 
                            <small>{{ message.time.toLocaleTimeString() }}</small>
                            <br>
                            {{ message.body }}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import Vue from "vue"

export default {
    props: ['current-channel', 'messages'],
    data() {
        return {
            noNewMessages: {}
        }
    },
    updated() {
        this.$el.scrollTop = this.$el.scrollHeight
    },
    methods: {
        requestOlderMessages(event) {
            if (this.noNewMessages[this.currentChannel] != true && event.target.scrollTop == 0 && this.messages[this.currentChannel] != [])
                console.log("Requesting older messages from server ...")
        }
    }
}
</script>


