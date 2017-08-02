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
    props: ['presences'],
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
            return Presence.list(this.presences, this.listBy).slice(0, -1)
        }
    }
}
</script>

<style>
</style>
