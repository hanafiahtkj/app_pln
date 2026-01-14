<script setup>
import { Link, usePage } from '@inertiajs/vue3'
import { reactive, computed, ref } from 'vue'

/**
 * Sidebar navigation component
 *
 * Features:
 * - Reads authenticated user and permissions from Inertia page props.
 * - Renders sections + items + optional children for nested navigation.
 * - Highlights:
 *    - Parent active when its own route is current.
 *    - Parent slightly highlighted when a child route is current.
 * - Dropdown behavior:
 *    - Parent with children shows a caret.
 *    - Clicking parent while on its route toggles children open/closed
 *      (without navigating).
 *    - Clicking parent while NOT on its route navigates to parent and
 *      ensures children are open.
 */

const page = usePage()
const user = computed(() => page.props.auth?.user)

// --- Permissions / route helpers ------------------------------------------

/**
 * Check if the current user has a given permission.
 * If no permission name is provided, it's treated as "no restriction".
 */
const hasPermission = permissionName =>
    !permissionName || (user.value?.permissions?.includes(permissionName) ?? false)

/**
 * Check if a given named route is the current route.
 * Uses both exact URL comparison and Inertia's route().current().
 */
const isCurrentRoute = routeName => {
    if (!routeName) return false

    const currentUrl = page.url.value
    const routeUrl = route(routeName)
    return currentUrl === routeUrl || route().current(routeName)
}

/**
 * Check if an item has children that are actually visible
 * based on the current user's permissions.
 */
const hasVisibleChildren = item => {
    if (!item?.children?.length) return false
    return item.children.some(child => hasPermission(child.permission))
}

/**
 * Check if ANY child route of this item is the current route.
 * Only considers children the user has permission to see.
 */
const isChildCurrentRoute = item => {
    if (!item?.children?.length) return false

    return item.children.some(
        child => hasPermission(child.permission) && isCurrentRoute(child.route)
    )
}

/**
 * Convenience helper: true if either the parent route OR any child route is active.
 */
const isParentOrChildActive = item => {
    return isCurrentRoute(item.route) || isChildCurrentRoute(item)
}

// --- Collapse / expand state for parents ----------------------------------

/**
 * Tracks collapsed state per parent item.
 * Structure: { [parentKey]: true | false }
 * - true  => collapsed
 * - false => expanded
 */
const collapsedParents = ref({})

/**
 * Generate a stable key for a parent item.
 * Prefer the route name, fallback to the item's name.
 */
const getParentKey = item => item.route || item.name

/**
 * Determine if a parent should be rendeamber as expanded (children visible).
 *
 * Rules:
 * - If item has no children or no visible children → never expanded.
 * - If we're on the parent route:
 *     Use collapsedParents to allow manual toggle.
 * - If a child route is active:
 *     Always expanded to give user context of where they are.
 * - Otherwise:
 *     Not expanded.
 */
const isParentExpanded = item => {
    if (!item?.children?.length || !hasVisibleChildren(item)) return false

    const key = getParentKey(item)

    // Child aktif → selalu buka
    if (isChildCurrentRoute(item)) {
        return true
    }

    // Kalau pernah di-toggle manual → pakai state
    if (key in collapsedParents.value) {
        return collapsedParents.value[key] === false
    }

    // Default: tertutup
    return false
}

/**
 * Handle clicks on the parent link:
 *
 * Behavior:
 * - If item has no children → do nothing special, let Inertia navigate.
 * - If we're on the parent route:
 *     Prevent navigation and toggle expanded/collapsed.
 * - If we're NOT on the parent route:
 *     Mark as expanded for when navigation completes, then let Inertia navigate.
 */
const onParentClick = (event, item) => {
    const hasChildren = item.children && hasVisibleChildren(item)
    const key = getParentKey(item)

    if (!hasChildren) {
        return
    }

    if (isCurrentRoute(item.route)) {
        // Already on parent route: toggle open/closed
        event.preventDefault()
        const collapsed = collapsedParents.value[key] === true
        collapsedParents.value[key] = !collapsed
        return
    }

    // Not on parent route:
    // Ensure that when we navigate to the parent, it will be expanded
    collapsedParents.value[key] = false
    // Let Inertia navigate normally
}

/**
 * Check if a section has at least one visible item.
 * Used to avoid rendering empty sections.
 */
const sectionHasVisibleItems = section => {
    if (!section?.items?.length) return false
    return section.items.some(
        item =>
            item.type !== 'divider' &&
            (hasPermission(item.permission) || (item.children && hasVisibleChildren(item)))
    )
}

// --- Navigation configuration ---------------------------------------------

/**
 * navigationSections:
 * - Array of sections
 * - Each section has an `items` array.
 * - Items can be:
 *    - A regular link (name, route, icon).
 *    - A parent with children (name, route, icon, children[]).
 *    - A divider (`{ type: 'divider' }`).
 *
 * Note: `icon` is raw SVG path markup rendeamber via v-html on an <svg>.
 */
const navigationSections = reactive([
    {
        items: [
            {
                name: 'Dashboard',
                route: 'dashboard',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />'
            },
            { type: 'divider' }
        ]
    },
    {
        items: [
            {
                name: 'Perencanaan',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="M20.25 14.25v4.5A2.25 2.25 0 0 1 18 21H6a2.25 2.25 0 0 1-2.25-2.25v-4.5m16.5-7.5V12a.75.75 0 0 1-.75.75h-3a.75.75 0 0 1-.75-.75V6.75h-6v5.25a.75.75 0 0 1-.75.75h-3a.75.75 0 0 1-.75-.75V6.75A2.25 2.25 0 0 1 6 4.5h12A2.25 2.25 0 0 1 20.25 6.75Z" />',
                route: 'admin.prk.index',
                permission: 'access-perencanaan',
                children: [
                    { name: 'PRK', route: 'admin.prk.index', permission: 'manage-prk' },
                    { name: 'Paket', route: 'admin.paket.index', permission: 'manage-paket' },
                    {
                        name: 'Enjiniring',
                        route: 'admin.enjiniring.index',
                        permission: 'manage-enjiniring'
                    }
                ]
            },
            { type: 'divider' }
        ]
    },
    {
        items: [
            {
                name: 'Pengadaan',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="M20.25 14.25v4.5A2.25 2.25 0 0 1 18 21H6a2.25 2.25 0 0 1-2.25-2.25v-4.5m16.5-7.5V12a.75.75 0 0 1-.75.75h-3a.75.75 0 0 1-.75-.75V6.75h-6v5.25a.75.75 0 0 1-.75.75h-3a.75.75 0 0 1-.75-.75V6.75A2.25 2.25 0 0 1 6 4.5h12A2.25 2.25 0 0 1 20.25 6.75Z" />',
                route: 'admin.rendan.index',
                permission: 'access-pengadaan',
                children: [
                    { name: 'Rendan', route: 'admin.rendan.index', permission: 'manage-rendan' },
                    { name: 'Lakdan', route: 'admin.lakdan.index', permission: 'manage-lakdan' },
                    { name: 'Kontrak', route: 'admin.kontrak.index', permission: 'manage-kontrak' }
                ]
            },
            { type: 'divider' }
        ]
    },
    {
        items: [
            {
                name: 'Konstruksi',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L6.832 19.82a4.5 4.5 0 0 1-1.897 1.13l-2.652.885a.75.75 0 0 1-.926-.264L.01 22.01l4.004-4.004a.75.75 0 0 1 .264-.926l-.885-2.652a4.5 4.5 0 0 1 1.13-1.897L16.862 4.487Z" />',
                route: 'admin.po.index',
                permission: 'manage-konstruksi'
            },
            { type: 'divider' }
        ]
    },
    {
        items: [
            {
                name: 'Pembayaran',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="M2.25 8.25h19.5M2.25 9h-.375a1.125 1.125 0 0 0 0 2.25h.375v.75c0 .621.504 1.125 1.125 1.125h14.25c.621 0 1.125-.504 1.125-1.125v-.75h.375a1.125 1.125 0 1 0 0-2.25h-.375V9h.375a1.125 1.125 0 1 0 0-2.25h-.375V6.75c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5Z" />',
                route: 'admin.pembayaran.index',
                permission: 'manage-pembayaran'
            },
            { type: 'divider' }
        ]
    },
    {
        items: [
            {
                name: 'Pengaturan',
                icon: '<path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 0 1 0 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 0 1-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 0 1-.22.128c-.331.183-.581.495-.644.869l-.213 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 0 1-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 0 1-1.369-.49l-1.297-2.247a1.125 1.125 0 0 1 .26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 0 1 0-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 0 1-.26-1.43l1.297-2.247a1.125 1.125 0 0 1 1.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281Z" />',
                route: 'admin.setting.index',
                permission: 'access-system-settings',
                children: [
                    { name: 'User Management', route: 'admin.user.index' },
                    { name: 'Access Control', route: 'admin.permission.role.index' },
                    { name: 'System Activity', route: 'admin.audit.index' },
                    { name: 'Theme Settings', route: 'admin.personalization.index' },
                    { name: 'Data Backup', route: 'admin.backup.index' },
                    { name: 'Login History', route: 'admin.login.history.index' },
                    { name: 'Security Settings', route: 'admin.setting.show' },
                    { name: 'Session Management', route: 'admin.sessions.index' },
                    { name: 'Health Status', route: 'admin.health.index' }
                ]
            },
            { type: 'divider' }
        ]
    }
])

const toggleParent = item => {
    const key = getParentKey(item)
    const collapsed = collapsedParents.value[key] === true
    collapsedParents.value[key] = !collapsed
}
</script>

<template>
    <aside
        data-sidebar-content
        class="nav-sidebar bg-cyan-800 text-gray-300 shadow-xl border-r border-gray-800"
        @click.stop>
        <nav class="flex-1 overflow-y-auto py-3 px-3" aria-labelledby="nav-heading">
            <ul class="space-y-1">
                <template v-for="(section, sectionIndex) in navigationSections" :key="sectionIndex">
                    <template v-if="sectionHasVisibleItems(section)">
                        <template v-for="(item, itemIndex) in section.items" :key="itemIndex">
                            <!-- <li v-if="item.type === 'divider'" class="my-2 px-2" role="separator">
                                <div class="h-px bg-gray-500/50"></div>
                            </li> -->

                            <li>
                                <a
                                    v-if="
                                        item.children &&
                                        hasPermission(item.permission) &&
                                        hasVisibleChildren(item)
                                    "
                                    type="button"
                                    @click="toggleParent(item)"
                                    :class="[
                                        'group flex items-center gap-3 p-3 rounded-xl transition-all duration-200 cursor-pointer',

                                        // 1. Parent Active Penuh: MERAH
                                        isCurrentRoute(item.route)
                                            ? 'bg-amber-300 text-white shadow-lg shadow-amber-600/30'
                                            : // 2. Child Active: Latar Belakang Hitam Opasitas 20%
                                            isChildCurrentRoute(item)
                                            ? 'bg-amber-300 text-white shadow-lg shadow-amber-600/30' // <-- Diganti dari bg-gray-800
                                            : // 3. Default/Hover
                                              'text-gray-200 hover:bg-black/20 hover:text-white focus:outline-none focus:ring-2 focus:ring-amber-600' // <-- Diganti dari hover:bg-gray-800
                                    ]">
                                    <svg
                                        :class="[
                                            'w-6 h-6 shrink-0 transition-colors duration-200',

                                            // LOGIKA ICON PARENT
                                            isCurrentRoute(item.route)
                                                ? 'text-white' // Aktif Penuh: Putih
                                                : isChildCurrentRoute(item)
                                                ? 'text-white' // CHILD AKTIF: Icon Amber
                                                : 'text-gray-300 group-hover:text-white'
                                        ]"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke-width="1.5"
                                        stroke="currentColor"
                                        aria-hidden="true"
                                        v-html="item.icon"></svg>

                                    <span class="text-base font-semibold flex-1">
                                        {{ item.name }}
                                    </span>

                                    <svg
                                        v-if="item.children && hasVisibleChildren(item)"
                                        :class="[
                                            'w-4 h-4 ml-2 shrink-0 transition-transform duration-200',
                                            isParentExpanded(item)
                                                ? 'rotate-180 text-white'
                                                : 'text-gray-300'
                                        ]"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke-width="1.5"
                                        stroke="currentColor"
                                        aria-hidden="true">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
                                    </svg>
                                </a>
                                <Link
                                    v-else-if="hasPermission(item.permission) && item.route"
                                    :href="route(item.route)"
                                    @click="onParentClick($event, item)"
                                    :class="[
                                        'group flex items-center gap-3 p-3 rounded-xl transition-all duration-200 cursor-pointer',

                                        // 1. Parent Active Penuh: MERAH
                                        isCurrentRoute(item.route)
                                            ? 'bg-amber-300 text-white shadow-lg shadow-amber-600/30'
                                            : // 2. Child Active: Latar Belakang Hitam Opasitas 20%
                                            isChildCurrentRoute(item)
                                            ? 'bg-amber-300 text-white shadow-lg shadow-amber-600/30' // <-- Diganti dari bg-gray-800
                                            : // 3. Default/Hover
                                              'text-gray-200 hover:bg-black/20 hover:text-white focus:outline-none focus:ring-2 focus:ring-amber-600' // <-- Diganti dari hover:bg-gray-800
                                    ]">
                                    <svg
                                        :class="[
                                            'w-6 h-6 shrink-0 transition-colors duration-200',

                                            // LOGIKA ICON PARENT
                                            isCurrentRoute(item.route)
                                                ? 'text-white' // Aktif Penuh: Putih
                                                : isChildCurrentRoute(item)
                                                ? 'text-white' // CHILD AKTIF: Icon Amber
                                                : 'text-gray-300 group-hover:text-white'
                                        ]"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke-width="1.5"
                                        stroke="currentColor"
                                        aria-hidden="true"
                                        v-html="item.icon"></svg>

                                    <span class="text-base font-semibold flex-1">
                                        {{ item.name }}
                                    </span>

                                    <svg
                                        v-if="item.children && hasVisibleChildren(item)"
                                        :class="[
                                            'w-4 h-4 ml-2 shrink-0 transition-transform duration-200',
                                            isParentExpanded(item)
                                                ? 'rotate-180 text-white'
                                                : 'text-gray-300'
                                        ]"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke-width="1.5"
                                        stroke="currentColor"
                                        aria-hidden="true">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
                                    </svg>
                                </Link>
                            </li>

                            <li
                                v-if="
                                    (item.children &&
                                        hasPermission(item.permission) &&
                                        hasVisibleChildren(item)) ||
                                    (hasPermission(item.permission) && item.route)
                                "
                                class="my-2 px-2"
                                role="separator">
                                <div class="h-px bg-gray-500/50"></div>
                            </li>

                            <li
                                v-if="
                                    item.children &&
                                    hasVisibleChildren(item) &&
                                    isParentExpanded(item)
                                ">
                                <ul class="ml-5 mt-1 space-y-1 border-l border-amber-400/50">
                                    <li v-for="child in item.children" :key="child.name">
                                        <Link
                                            v-if="hasPermission(child.permission)"
                                            :href="route(child.route)"
                                            :class="[
                                                'block py-2 pl-4 pr-3 text-sm rounded-r-lg transition-colors duration-200 cursor-pointer',
                                                isCurrentRoute(child.route)
                                                    ? 'font-bold text-amber-400 bg-black/20' // <-- Diganti dari bg-gray-800
                                                    : 'text-gray-300 hover:text-amber-400 hover:bg-black/20' // <-- Diganti dari hover:bg-gray-800
                                            ]">
                                            <span class="text-sm font-medium">
                                                {{ child.name }}
                                            </span>
                                        </Link>
                                    </li>
                                </ul>
                            </li>
                        </template>
                    </template>
                </template>
            </ul>
        </nav>
    </aside>
</template>

<style scoped>
.bg-green {
    background-color: #055971;
}
</style>
