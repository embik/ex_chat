<template>
    <nav class="menu">
        <p class="menu-label">Users online</p>
        <ul class="menu-list">
            <li v-for="user in users">
                <a>{{ user["name"] }}</a>
            </li>
        </ul>
    </nav>
</template>

<script>
import {Presence} from "phoenix"

export default {
    props: ['presences', 'current-channel'],
    mounted() {
    },
    methods: {
        listBy(user, {metas: metas}) {
            return {
                name: user
            }
        }
    },
    computed: {
        users: function() {
            if (this.presences[this.currentChannel]) {
                return Presence.list(this.presences[this.currentChannel], this.listBy).slice(0, -1)
            } else {
                return []
            }
        }
    }
}
</script>

<style>
</style>
