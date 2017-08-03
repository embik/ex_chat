<template>
    <nav class="menu">
        <p class="menu-label">
            Rooms
            <!--<a style="float:right;">Add</a>-->
        </p>
        <ul class="menu-list">
            <li v-for="room in rooms">
                <a v-bind:class="isCurrentRoom(room)" v-on:click="internalCurrentRoom = room">
                    #{{ room }}
                </a>
            </li>
        </ul>
    </nav>
</template>

<script>
export default {
    props: ['rooms', 'value', 'initial-room'],
    data() {
        return {
            internalCurrentRoom: ''
        }
    },
    mounted() {
        console.log(this.$parent)
        this.internalCurrentRoom = this.initialRoom
    },
    watch: {
        'internalCurrentRoom': function() {
            this.$emit('input', this.internalCurrentRoom)
        }
    },
    methods: {
        isCurrentRoom(room) {
            if (this.internalCurrentRoom == room)
                return "is-active"
            return ""
        }
    }
}
</script>
