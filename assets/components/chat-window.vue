<template>
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
export default {
    props: ['current-channel', 'messages'],
    updated() {
        this.$el.scrollTop = this.$el.scrollHeight
    }
}
</script>


