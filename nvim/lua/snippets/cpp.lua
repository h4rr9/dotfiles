local ls = require 'luasnip'

local i = ls.insert_node
local t = ls.text_node

local fmt = function(code)
    local lines = {}
    for s in code:gmatch('[^\r\n]+') do table.insert(lines, s) end
    return lines
end

local snippets = {}

-- cp_template
snippets.cp_template = {
    t(fmt [[
#include <bits/stdc++.h>
using namespace std;

#ifdef _STACK
#include <sys/resource.h>
#endif

#define ll long long
#define ld long double
#define ar array
#define pii pair<int, int>
#define pll pair<ll,ll>
#define vt vector
#define pb push_back
#define mp make_pair
#define F first
#define S second
#define all(c) (c).begin(), (c).end()
#define sz(x) (int)(x).size()

#define F_OR(i, a, b, s)                                                       \
    for (int i = (a); (s) > 0 ? i < (b) : i > (b); i += (s))
#define F_OR1(e) F_OR(i, 0, e, 1)
#define F_OR2(i, e) F_OR(i, 0, e, 1)
#define F_OR3(i, b, e) F_OR(i, b, e, 1)
#define F_OR4(i, b, e, s) F_OR(i, b, e, s)
#define GET5(a, b, c, d, e, ...) e
#define F_ORC(...) GET5(__VA_ARGS__, F_OR4, F_OR3, F_OR2, F_OR1)
#define FOR(...) F_ORC(__VA_ARGS__)(__VA_ARGS__)
#define EACH(x, a) for (auto &x : a)
#define RANGE(a) for (auto i = a.begin(); i != a.end(); ++i)
#define RRANGE(a) for (auto i = a.rbegin(); i != a.rend(); ++i)

template <class A> void read(vt<A> &v);
template <class A, size_t S> void read(ar<A, S> &a);
template <class T> void read(T &x) { cin >> x; }
void read(double &d) {
    string t;
    read(t);
    d = stod(t);
}
void read(long double &d) {
    string t;
    read(t);
    d = stold(t);
}
template <class A, class B> void read(pair<A, B> &p) {
    read(p.first);
    read(p.second);
}
template <class H, class... T> void read(H &h, T &...t) {
    read(h);
    read(t...);
}
template <class A> void read(vt<A> &x) {
    EACH(a, x)
    read(a);
}
template <class A, size_t S> void read(array<A, S> &x) {
    EACH(a, x)
    read(a);
}

string to_string(char c) { return string(1, c); }
string to_string(bool b) { return b ? "true" : "false"; }
string to_string(const char *s) { return string(s); }
string to_string(string s) { return s; }
string to_string(vt<bool> v) {
    string res;
    FOR(sz(v))
    res += char('0' + v[i]);
    return res;
}

template <size_t S> string to_string(bitset<S> b) {
    string res;
    FOR(S)
    res += char('0' + b[i]);
    return res;
}

template <class A, class B> string to_string(pair<A, B> p) {
    string res;
    res += "{" + to_string(p.first) + ", " + to_string(p.second) + "}";
    return res;
}

template <class T> string to_string(T v) {
    bool f = 1;
    string res;
    EACH(x, v) {
        if (!f)
            res += ' ';
        f = 0;
        res += to_string(x);
    }
    return res;
}

template <class A> void write(A x) { cout << to_string(x); }
template <class H, class... T> void write(const H &h, const T &...t) {
    write(h);
    write(t...);
}
void print() { write("\n"); }
template <class H, class... T> void print(const H &h, const T &...t) {
    write(h);
    if (sizeof...(t))
        write(' ');
    print(t...);
}

void solve() {]]), i(0, 'CODE HERE'), t(fmt [[}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);

#ifdef _STACK
    rlimit R;
    getrlimit(RLIMIT_STACK, &R);
    R.rlim_cur = R.rlim_max;
    setrlimit(RLIMIT_STACK, &R);
#endif

    int t = 1;
    read(t);
    FOR(t) {
        write("Case #", i + 1, ": ");
        solve();
    }
}

    ]])
}

snippets.first_true = t(fmt [[
ll FIRSTTRUE(std::function<bool(ll)> f, ll lb, ll rb){
	while (lb < rb){
		ll mb = (lb + rb) / 2;
		f(mb) ? rb = mb : lb = mb + 1;
	}
	return lb;
}
]])

snippets.last_true = t(fmt [[
ll LASTTRUE(std::function<bool(ll)> f, ll lb, ll rb){
	while (lb < rb) {
		ll mb = (lb + rb + 1) / 2;
		f(mb) ? lb = mb : rb = mb - 1;
	}
	return lb;
}
]])

snippets.binary_tree = t(fmt [[
template <typename node, typename update> struct Segment_Tree {
    int n;
    int h;
    vt<node> t;
    vt<update> d;
    vt<int> roots;
    update identity;

    Segment_Tree(int n) : n(n), t(2 * n, node()), d(n) {

        node identity;
        FOR(i, n)
        t[i + n] = node(identity.v, i);

        FOR(i, n - 1, 0, -1)
        t[i] = node::merge(t[i << 1], t[i << 1 | 1]);

        h = sizeof(int) * 8 - __builtin_clz(n);
    }

    template <class T> Segment_Tree(vt<T> a) : n(sz(a)), t(2 * n), d(n) {

        FOR(i, n)
        t[i + n] = node(a[i], i);

        FOR(i, n - 1, 0, -1)
        t[i] = node::merge(t[i << 1], t[i << 1 | 1]);

        h = sizeof(int) * 8 - __builtin_clz(n);
    }

    node query(int l, int r, bool lazy = true) { // sum on interval [l, r)
        node l_res, r_res;

        if (lazy)
            push(l, l + 1), push(r - 1, r);

        for (l += n, r += n; l < r; l >>= 1, r >>= 1) {
            if (l & 1)
                l_res = node::merge(l_res, t[l++]);
            if (r & 1)
                r_res = node::merge(t[--r], r_res);
        };

        l_res = node::merge(l_res, r_res);

        return l_res;
    }

    void modify(int p, update &upd) {

        upd.apply(t[p + n]);
        for (p += n; p > 1; p >>= 1)
            if (p & 1)
                t[p >> 1] = node::merge(t[p ^ 1], t[p]);
            else
                t[p >> 1] = node::merge(t[p], t[p ^ 1]);
    }

    void lazy_modify(int l, int r, update &upd) {
        if (upd.is_identity())
            return;
        push(l, l + 1);
        push(r - 1, r);
        bool cl = false, cr = false;
        for (l += n, r += n; l < r; l >>= 1, r >>= 1) {
            if (cl)
                calc(l - 1);
            if (cr)
                calc(r);
            if (l & 1)
                apply(l++, upd), cl = true;
            if (r & 1)
                apply(--r, upd), cr = true;
        }
        for (--l; r > 0; l >>= 1, r >>= 1) {
            if (cl)
                calc(l);
            if (cr && (!cl || l != r))
                calc(r);
        }
    }

    void push(int l, int r) {
        int s = h;
        for (l += n, r += n - 1; s > 0; --s)
            for (int i = l >> s; i <= r >> s; ++i)
                if (not d[i].is_identity()) {
                    apply(i << 1, d[i]);
                    apply(i << 1 | 1, d[i]);
                    d[i] = identity;
                }
    }

    void calc(int p) {
        if (d[p].is_identity())
            t[p] = node::merge(t[p << 1], t[p << 1 | 1]);
        else
            d[p].apply(t[p]);
    }

    void apply(int p, update &upd) {
        upd.apply(t[p]);
        if (p < n)
            d[p].combine(upd);
    }

    void init_roots() {
        vector<int> roots_r;
        for (auto l = n, r = n << 1; l < r; l >>= 1, r >>= 1) {
            if (l & 1)
                roots.push_back(l++);
            if (r & 1)
                roots_r.push_back(--r);
        }
        roots.insert(roots.end(), roots_r.rbegin(), roots_r.rend());
    }

    /**
     * @brief binary search in log(n), don't forget to call init_roots()
     *
     * @param x value to search for
     * @return index of found element
     */
	int binary_search(int x) {

			if (query(0, n).v < x)
				return -1;

			auto pred = [x, this](int i) {
				if (!d[i >> 1].is_identity()) {
					apply(i, d[i >> 1]);
					apply(i ^ 1, d[i >> 1]);
					d[i >> 1] = identity;
				}
				return this->t[i].v >= x;
			};
			int root = *find_if(all(roots), pred);

			while (root < n && t[root].v >= x) {

				root <<= 1; // go to left child
				if (!pred(root))
					root |= 1; // go to right child
			}

			return root - n;
		}
};

template <typename T> struct node {

    T v = 0, ind = -1, tl = -1, tr = -2;

    node() {}
    node(T x, T i) : v(x), ind(i), tl(i), tr(i) {}
    node(T v, T ind, T tl, T tr) : v(v), ind(ind), tl(tl), tr(tr) {}

    static node merge(const node &l_node, const node &r_node) {
        T tl, tr;
        if (l_node.tl >= 0 and r_node.tl >= 0)
            tl = min(l_node.tl, r_node.tl);
        else
            tl = max(l_node.tl, r_node.tl);
        tr = max(l_node.tr, r_node.tr);

        T v = max(l_node.v, r_node.v);
        T ind = (l_node.v == v) ? l_node.ind : r_node.ind;

        return node(v, ind, tl, tr);
    }
};

template <typename T> struct update {

    T v = 0;
    T ql = 0, qr = 0;
    update() {} // identity element
    update(int a, int ql, int qr) : ql(ql), qr(qr) { v = a; }

    bool is_identity() {
        update identity;
        return v == identity.v;
    }

    void combine(const update &other) {
        // applied update from other(provided and parent)
        ql = other.ql, qr = other.qr;
        v += other.v;
    }
    void apply(node<T> &s) { // apply lazy value on segment

        s.v += v;
    }
};
]])

snippets.fenwich_tree = t(fmt [[
template <class T> struct Fenwick_Tree {

    int n;
    vt<T> t;

    Fenwick_Tree(int n) : n(n), t(n, 0) {}
    Fenwick_Tree(vt<T> &v) : n(sz(v)), t(n, 0) {

        FOR(k, n) { modify(k, v[k]); }
    }

    T query(int k) { // [0,k)
        T ans = 0;
        for (; k > 0; k &= k - 1)
            ans += t[k - 1];
        return ans;
    }

    T query(int a, int b) { // [a,b)
        T l_ans = 0, r_ans = 0;
        if (a > 0)
            l_ans = query(a);

        r_ans = query(b);

        return r_ans - l_ans;
    }

    void modify(int k, T x) { // modifies at k
        for (; k < n; k |= k + 1)
            t[k] += x;
    }

    T lower_bound(T sum) {
        if (sum < 0)
            return -1;
        int pos = 0;
        for (int pw = 1 << 25; pw; pw >>= 1) {
            if (pos + pw <= n and t[pos + pw - 1] < sum)
                pos += pw, sum -= t[pos - 1];
        }

        return pos;
    }
}
]])

snippets.fenwich_tree_2d = t(fmt [[
template <typename T> struct Fenwick_Tree_2D {
    int n, m;
    vt<vt<T>> t;

    Fenwick_Tree_2D(int n, int m) : n(n), m(m), t(n, vt<T>(m, 0)) {}

    Fenwick_Tree_2D(vt<vt<T>> &v)
        : n(sz(v)), m(sz(*v.begin())), t(n, vt<T>(m, 0)) {

        FOR(i, n)
        FOR(j, m) { modify(i, j, v[i][j]); }
    }

    void modify(int p, int q, T x) {
        for (int i = p; i < n; i |= i + 1)
            for (int j = q; j < m; j |= j + 1)
                t[i][j] += x;
    }

    T query(int p, int q) {
        ll res = 0;

        for (int i = p; i > 0; i &= i - 1)
            for (int j = q; j > 0; j &= j - 1)
                res += t[i - 1][j - 1];

        return res;
    }

    T query_single(int p, int q) {

        T v1 = query(p + 1, q + 1);
        T v2 = query(p, q + 1);
        T v3 = query(p + 1, q);
        T v4 = query(p, q);

        T res = v1 - v2 - v3 + v4;
    }
};
]])

snippets.persistant_segment_tree = t(fmt [[
template <typename T> struct Node {

    T v = 0, tr = -1, tl = -2;

    Node *l, *r;

    Node() : l(nullptr), r(nullptr) {}
    Node(T x, int i) : v(x), tr(i + 1), tl(i), l(nullptr), r(nullptr) {}

    Node(Node *l, Node *r) : l(l), r(r) { merge(); }

    Node(Node *vertex, T x) {

        v = x;
        tl = vertex->tl;
        tr = vertex->tr;
        l = vertex->l;
        r = vertex->r;
    }

    void merge() {
        assert(l != nullptr and r != nullptr);

        if (l->tl >= 0 and r->tl >= 0)
            tl = min(l->tl, r->tl);
        else
            tl = max(l->tl, r->tl);
        tr = max(l->tr, r->tr);

        v = l->v + r->v;
    }
};

template <typename T> struct PSGT {

    deque<Node<T>> heap;

    Node<T> *heap_memory(const Node<T> &new_node) {
        heap.push_back(new_node);
        return &heap.back();
    }

    Node<T> *build(int tl, int tr) { //[0,n)
        if (tl + 1 < tr) {
            int tm = tl + (tr - tl) / 2;
            return heap_memory(Node<T>(build(tl, tm), build(tm, tr)));
        } else {
            heap_memory(Node<T>());
        }
    }

    Node<T> *build(vt<T> &vec, int tl, int tr) { // [0,n)
        if (tl + 1 < tr) {
            int tm = tl + (tr - tl) / 2;
            return heap_memory(Node<T>(build(vec, tl, tm), build(vec, tm, tr)));
        } else {
            return heap_memory(Node<T>(vec[tl], tl));
        }
    }

    Node<T> *modify(Node<T> *v, int pos, T diff) {

        if (v->tl == v->tr - 1) {
            return heap_memory(Node<T>(v, diff));
        }

        int tm = v->tl + (v->tr - v->tl) / 2;

        if (pos < tm)
            return heap_memory(Node<T>(modify(v->l, pos, diff), v->r));

        else
            return heap_memory(Node<T>(v->l, modify(v->r, pos, diff)));
    }

    T query(Node<T> *v, int ql, int qr) { // [0,n)

        if (ql >= v->tr or qr <= v->tl)
            return 0;

        if (ql <= v->tl and qr >= v->tr)
            return v->v;

        return query(v->l, ql, qr) + query(v->r, ql, qr);
    }

    Node<T> *clone(Node<T> *v) { return heap_memory(Node<T>(v->l, v->r)); }
};
]])

snippets.debugger = t(fmt [[
void DBG() { std::cerr << "]" << std::endl; }
template <class H, class... T> void DBG(H h, T... t)
{
	std::cerr << to_string(h);
	if (sizeof...(t))
		std::cerr << ", ";
	DBG(t...);
}
#ifdef _DEBUG
#define dbg(...)                                                              \
	std::cerr << "LINE(" << __LINE__ << ") -> [" << #__VA_ARGS__ << "]: [",        \
	DBG(__VA_ARGS__)
#else
#define dbg(...) 0
#endif
]])

snippets.kosaraju = t(fmt [[
void primary_dfs(int node, vt<int> adj[], vt<bool> &visited,
                 vt<int> &processed) {
    if (visited[node])
        return;
 
    visited[node] = true;
    EACH(c_node, adj[node])
    primary_dfs(c_node, adj, visited, processed);
 
    processed.pb(node);
}
 
void secondary_dfs(int node, vt<int> adj[], vt<bool> &visited,
                   vt<int> &component) {
 
    if (visited[node])
        return;
 
    visited[node] = true;
    component.pb(node);
 
    EACH(c_node, adj[node])
    secondary_dfs(c_node, adj, visited, component);
}
 
void kosaraju(int n, vt<int> adj[], vt<vt<int>> &scc) {
 
    vt<bool> visited(n, false);
    vt<int> processed;
 
    FOR(n)
    if (!visited[i]) {
        primary_dfs(i, adj, visited, processed);
    }
 
    vt<int> rev_adj[n];
 
    FOR(node, n)
    EACH(c_node, adj[node])
    rev_adj[c_node].pb(node);
 
    reverse(all(processed));
    fill(all(visited), false);
 
    EACH(node, processed) {
 
        vt<int> component;
        if (!visited[node])
            secondary_dfs(node, rev_adj, visited, component);
        if (sz(component))
            scc.pb(component);
    }
}
]])

snippets.edmonds_karp = t(fmt [[
template <class T> struct EdmondsKarp {

    struct Edge {
        int dest, back;
        T f, c;
    };

    int n;

    vt<vt<Edge>> g;
    vt<Edge *> aug_path;

    EdmondsKarp(int n) : g(n), aug_path(n){};

    EdmondsKarp(int n, vt<int> adj[], vt<vt<T>> &cap) : g(n), aug_path(n) {

        this->n = n;

        FOR(s, n)
        EACH(t, adj[s]) {
            ae(s, t, cap[s][t], cap[t][s]);
        }
    }

    void ae(int s, int t, T c, T r_c = 0) {
        if (s == t)
            return;

        g[s].pb({t, sz(g[t]), 0, c});
        g[t].pb({s, sz(g[s]) - 1, 0, r_c});
    }

    T bfs(int s, int t) {
        vt<bool> vis(n, false);
        vis[s] = true;

        queue<pair<int, T>> q;
        q.push(mp(s, numeric_limits<T>::max()));

        while (!q.empty()) {
            int cur = q.front().F;
            T flow = q.front().S;
            q.pop();

            EACH(e, g[cur]) {
                if (!vis[e.dest] and e.c > 0) {
                    vis[e.dest] = true;
                    aug_path[e.dest] = &e;
                    T new_flow = min(flow, e.c);

                    if (e.dest == t)
                        return new_flow;
                    q.push(mp(e.dest, new_flow));
                }
            }
        }

        return 0;
    }

    T mf(int s, int t) {
        T flow = 0, new_flow;

        while ((new_flow = bfs(s, t))) {
            flow += new_flow;
            for (int node = t; node != s;
                 node = g[node][aug_path[node]->back].dest) {
                Edge &e = *aug_path[node];
                e.c -= new_flow;
                e.f += new_flow;

                Edge &back = g[e.dest][e.back];

                back.c += new_flow;
                back.f -= new_flow;
            }
        }

        return flow;
    }
};
]])

snippets.push_relabel = t(fmt [[
template <class T> struct PushRelabel {

    struct Edge {
        int dest, back;
        T f, c;
    };

    int n;
    vt<int> ht;
    vt<vt<Edge>> g;
    vt<Edge *> cur;
    vt<vt<int>> hs;
    vt<T> ec;

    PushRelabel(int n) : g(n), cur(n){};

    PushRelabel(int n, vt<int> adj[], vt<vt<T>> &cap) : g(n), cur(n) {
        FOR(s, n)
        EACH(t, adj[s]) {
            ae(s, t, cap[s][t], cap[t][s]);
        }
    }

    void ae(int s, int t, T cap, T rcap = 0) {
        assert(s != t);

        g[s].pb({t, sz(g[t]), 0, cap});
        g[t].pb({s, sz(g[s]) - 1, 0, rcap});
    }

    void p(Edge &e, T f) {
        Edge &back = g[e.dest][e.back];
        if (!ec[e.dest] && f)
            hs[ht[e.dest] ].push_back(e.dest);
        e.f += f;
        e.c -= f;
        ec[e.dest] += f;
        back.f -= f;
        back.c += f;
        ec[back.dest] -= f;
    }

    T mf(int s, int t) {
        int n = sz(g);

        ht.assign(n, 0);
        hs.assign(2 * n, vt<int>());
        ec.assign(n, 0);

        vt<int> co(2 * n);
        co[0] = n - 1, ht[s] = n, ec[t] = 1;

        FOR(n) cur[i] = g[i].data();
        EACH(e, g[s]) p(e, e.c);

        for (int hi = 0;;) {
            while (hs[hi].empty())
                if (!hi--)
                    return -ec[s];

            int u = hs[hi].back();
            hs[hi].pop_back();

            while (ec[u] > 0) {
                if (cur[u] == g[u].data() + sz(g[u])) {
                    ht[u] = 1e9;
                    EACH(e, g[u])
                    if (e.c and ht[u] > ht[e.dest] + 1) {
                        ht[u] = ht[e.dest] + 1, cur[u] = &e;
                    }
                    if (++co[ht[u] ], !--co[hi] and hi < n)
                        FOR(n)
                    if (hi < ht[i] and ht[i] < n)
                        --co[ht[i] ], ht[i] = 1 + n;

                    hi = ht[u];
                } else if (cur[u]->c and ht[u] == ht[cur[u]->dest] + 1)
                    p(*cur[u], min(ec[u], cur[u]->c));
                else
                    ++cur[u];
            }
        }
    }
};
]])

snippets.dfs_iterative = t(fmt [[
bool dfs(int start, int n, vt<pll> adj[]) {

    stack<int> s;
    vt<bool> visited(n, false);

    s.push(start);

    while (!s.empty()) {
        int a = s.top();
        s.pop();
        if (visited[a])
            continue;
        visited[a] = true;
		
		// process node here
		
        EACH(u, adj[a]) {
            int b = u.F;
            s.push(b);
        }
    }

    return false;
}
]])

snippets.union_find = t(fmt [[
template <class Container, class T = int> struct union_find {

    Container parent;

    typedef
        typename conditional<is_same<Container, vector<T>>::value, vector<T>,
                             unordered_map<T, int>>::type Rank_Container;

    Rank_Container rank;

    template <typename C = Container,
              typename = typename enable_if<is_same<C, vector<T>>::value>::type,
              typename = C>
    union_find(int n) {
        for (int i = 0; i < n; i++) {
            parent.pb(i);
            rank.pb(0);
        }
    }

    template <typename C = Container,
              typename = typename enable_if<
                  is_same<C, unordered_map<T, T>>::value>::type,
              typename = C>
    union_find(vt<T> nodes) {
        for (auto c : nodes) {
            parent[c] = c;
            rank[c] = 0;
        }
    }

    T find(T k) {
        if (parent[k] != k) {
            parent[k] = find(parent[k]);
        }
        return parent[k];
    }

    void join(T a, T b) {
        T x = find(a);
        T y = find(b);

        if (x == y) {
            return;
        }

        if(rank[x] < rank[y])
			swap(x, y);

		parent[y] = x;
		if(rank[x] == rank[y])
			rank[x]++;
    }
    int size() { return sz(parent); }
};

]])

snippets.two_satisfiability = t(fmt [[
// import kosaraju

int neg(int x, int n) { return (x < n) ? x + n : x - n; }

int get_truth_value(int x, int n) { return x < n; }

bool solve_2SAT(int n, vt<int> adj[], vt<bool> &solution) {

    vt<vt<int>> scc;
    kosaraju(2 * n, adj, scc);
    EACH(c, scc)
    dbg(c);
    vt<int> comp_id(2 * n, -1);
    int num_comp = 0;

    EACH(c, scc) {
        EACH(v, c)
        comp_id[v] = num_comp;
        ++num_comp;
    }

    FOR(n)
    if (comp_id[i] == comp_id[neg(i, n)])
        return false;
    else
        solution[i] = comp_id[i] > comp_id[neg(i, n)];

    return true;
}
]])

snippets.heirholzer_undirected = t(fmt [[
void dfs(int node, vt<int> adj[], vt<bool> &visited) {
    if (visited[node])
        return;

    visited[node] = true;

    EACH(c_node, adj[node])
    dfs(c_node, adj, visited);
}

bool heirholzer(int n, vt<int> adj[], vt<int> &eulerian_circuit) {

    vt<int> degree(n, 0);
    FOR(node, n) { degree[node] += sz(adj[node]); }

    // circuit --  check if out_degee in equal to indegree
    //
    //
    // path -- check if one node has extra degree and another node has extra
    // degree and check if degree is equal to degree for other nodes

    FOR(n)
    if (1 & degree[i])
        return false;

    vt<bool> visited(n, false);

    dfs(0, adj, visited);

    FOR(n)
    if (!visited[i] and degree[i] > 0)
        return false;

    // heirholzer begins

    vt<int> adj_copy[n];

    FOR(n) {
        sort(all(adj[i]));
        adj_copy[i] = adj[i];
    }

    stack<int> s;
    s.push(0);

    while (!s.empty()) {
        int v = s.top();

        if (degree[v] == 0 and degree[v] == 0) {
            eulerian_circuit.pb(v);
            s.pop();
        } else {
            int node = adj_copy[v][degree[v] - 1];

            adj_copy[v].pop_back();
            adj_copy[node].erase(lower_bound(all(adj_copy[node]), v));

            --degree[v];
            --degree[node];

            s.push(node);
        }
    }

    return true;
}
]])

snippets.heirholzer_directed = t(fmt [[
bool heirholzer(int n, vt<int> adj[], vt<int> &eulerian_circuit) {

    vt<int> in_degree(n, 0), out_degree(n, 0);
    FOR(node, n) {
        out_degree[node] += sz(adj[node]);
        EACH(c_node, adj[node])
        ++in_degree[c_node];
    }
    // circuit --  check if out_degee in equal to indegree
    //
    //
    // path -- check if one node has extra degree and another node has extra
    // degree and check if degree is equal to degree for other nodes

    FOR(n)
    if (in_degree != out_degree)
        return false;
    // heirholzer begins

    vt<int> adj_copy[n];

    FOR(n) { adj_copy[i] = adj[i]; }

    stack<int> s;
    s.push(0);

    while (!s.empty()) {
        int v = s.top();

        if (out_degree[v] == 0) {
            eulerian_circuit.pb(v);
            s.pop();
        } else {
            int node = adj_copy[v][out_degree[v] - 1];

            adj_copy[v].pop_back();

            --out_degree[v];
            --in_degree[node];

            s.push(node);
        }
    }

    return true;
}
]])

snippets.hamiltonian_path = t(fmt [[
int hamiltonian_path_count(int n, vt<int> rev_adj[]) { // directed graph

    auto bit = [](int i, int mask) { return (1 << i) & mask; };

    int num_nodes =
        (1 << (n - 1)); // solve for n-1 nodes and do last node indepenantly

    vt<vt<int>> dp(num_nodes, vt<int>(n, 0));
    dp[1][0] = 1;

    FOR(mask, num_nodes) { // solving for n-1 nodes
        FOR(node, n - 1) {
            if (bit(node, mask)) {
                EACH(p_node, rev_adj[node]) {
                    if (bit(p_node, mask)) {
                        (dp[mask][node] += dp[mask ^ (1 << node)][p_node]) %=
                            MOD;
                    }
                }
            }
        }
    }

    int mask = (1 << n) - 1;
    int ans = 0;
    EACH(p_node, rev_adj[n - 1]) { // know answer for n-1 nodes and hamiltonian
                                   // path must end at node n-1.
        (ans += dp[mask ^ (1 << (n - 1))][p_node]) %= MOD;
    }

    return ans;
}
]])

snippets.kruskals = t(fmt [[
void kruskals(int n, int m, vt<pair<ll, pii>> &edges, vt<pair<ll, pii>> &mst) {

	sort(all(edges));

	union_find<vector<int>> disjoint(n);

	EACH(e, edges) {
		int u = e.S.F, v = e.S.S;

		int u_parent = disjoint.find(u);
		int v_parent = disjoint.find(v);

		if (u_parent != v_parent) {
			mst.pb(e);
			disjoint.join(u, v);
		}
	}
}
]])

snippets.dijkstra = t(fmt [[
void dijkstra(int n, int start, vt<pii> adj[], vt<ll> &distance) {
    FOR(n) distance[i] = LLONG_MAX;
 
    priority_queue<pair<ll, int>, vt<pair<ll, int>>, greater<pair<ll, int>>> pq;
    vt<bool> visited(n, false);
 
    distance[start] = 0;
 
    pq.push(mp(0, start));
 
    while (!pq.empty()) {
        auto a = pq.top().S;
        pq.pop();
 
        if (!visited[a]) {
            visited[a] = true;
            EACH(u, adj[a]) {
                int b = u.F, w = u.S;
                    if (distance[a] + w < distance[b]) {
                        distance[b] = distance[a] + w;
                        pq.push(mp(distance[b], b));
                    }
            }
        }
    }
}
]])

snippets.bellman_ford = t(fmt [[
void bellman_ford(int n, int start, vt<pll> adj[], vt<ll> &distances,
                  int num_iters = 1) {
 
    if (num_iters > 1) {
        fill(all(distances), LLONG_MAX);
        distances[start] = 0;
    }
 
    FOR(k, num_iters) {
        bool decreased = false;
        {
            FOR(i, n)
            if (distances[i] != LLONG_MAX)
                EACH(e, adj[i]) {
                    if (distances[i] + e.S < distances[e.F]) {
                        decreased = true;
                        distances[e.F] = distances[i] + e.S;
                    }
                }
        }
        if (!decreased)
            break;
    }
}
]])

snippets.floyd_warshall = t(fmt [[
void floyd_warshall(int n, vt<pll> adj[], vt<vt<ll>> &distances) {
 
    FOR(n) {
        fill(all(distances[i]), LLONG_MAX);
        distances[i][i] = 0;
        EACH(x, adj[i]) { distances[i][x.F] = min(distances[i][x.F], x.S); }
    }
 
    FOR(k, n)
    FOR(i, n)
    FOR(j, n)
    if (distances[i][k] != LLONG_MAX)
        if (distances[k][j] != LLONG_MAX)
            distances[i][j] =
                min(distances[i][j], distances[i][k] + distances[k][j]);
}
]])

snippets.randint = t(fmt [[
std::mt19937 mt_rng(
		std::chrono::steady_clock::now().time_since_epoch().count());
ll randint(ll a, ll b)
{
	return std::uniform_int_distribution<ll>(a, b)(mt_rng);
}

]])

snippets.neal_hash = t(fmt [[
struct custom_hash {
	static uint64_t splitmix64(uint64_t x) {
		// http://xorshift.di.unimi.it/splitmix64.c
		x += 0x9e3779b97f4a7c15;
		x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
		x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
		return x ^ (x >> 31);
	}

	size_t operator()(uint64_t x) const {
		static const uint64_t FIXED_RANDOM = chrono::steady_clock::now().time_since_epoch().count();
		return splitmix64(x + FIXED_RANDOM);
	}
};
]])

snippets.hash_pair = t(fmt [[
struct pair_hash {
	size_t operator()(const pair<int, int>& x) const
	{
		return hash<long long>()(
				((long long)x.first) ^ (((long long)x.second) << 32));
	}
};
]])

snippets.leetcode_treenode = t(fmt [[
struct TreeNode {
	int val;
	TreeNode *left;
	TreeNode *right;
	TreeNode(int x) : val(x), left(NULL), right(NULL) {}

    TreeNode(string data)
    {
        int len = data.length();
        int num = 0, sign = 1;
        bool nil = false, number = false;
        TreeNode* root = NULL;
        queue<TreeNode**> q;
        q.push(&root);
        for (int i(1); i < len; ++i)
        {
            auto ch = data[i];
            if (ch == ',' || ch == ']')
            {
                auto node = q.front();
                q.pop();
                if (!nil && number)
                {
                    *node = new TreeNode(sign * num);
                    q.push(&((*node)->left));
                    q.push(&((*node)->right));
                }
                sign = 1;
                num = nil = number = 0;
            }
            else if (ch == 'n')
            {
                nil = true;
                i += 3;
            }
            else if (ch == '-')
                sign = -1;
            else if (ch == ' ');
            else
            {
                number = true;
                num *= 10;
                num += ch - '0';
            }
        }
        *this = *root;
    }
};

]])

snippets.mos_queries = t(fmt [[
template <typename T> struct MoQueries {

#define K(x) pii(x.F / bulk, x.S ^ -(x.F / bulk & 1))

    const size_t bulk = 555; // ~ N / sqrt(Q)
    vt<int> v, counts;
    int ans;

    MoQueries(vt<T> &v) : v(v), counts(sz(v), 0), ans(0) {}

    void add(size_t ind, bool end) {
        ++counts[v[ind] ];
        if (counts[v[ind] ] == 1)
            ++ans;
    }

    void del(size_t ind, bool end) {
        --counts[v[ind] ];
        if (counts[v[ind] ] == 0)
            --ans;
    }

    int calc() { return ans; }

    void process(vt<pair<size_t, size_t>> &queries, vt<T> &res) {

        size_t L = 0, R = 0;
        vt<int> s(sz(queries));
        iota(all(s), 0);

        sort(all(s),
             [&](int s, int t) { return K(queries[s]) < K(queries[t]); });

        EACH(qi, s) {

            auto q = queries[qi];

            while (L > q.F)
                add(--L, false);
            while (R < q.S)
                add(R++, true);
            while (L < q.F)
                del(L++, false);
            while (R > q.S)
                del(--R, true);

            res[qi] = calc();
        }
    }
};
]])

snippets.coord_compression = t(fmt [[
/**
 * @brief coordinate compression yoinked from
 * https://github.com/shugo256/AlgorithmLibrary/blob/master/DataStructures/coordinate_compression.cpp
 *
 * @tparam T - datatype of org
 * @param org - vector containing data needing compression
 * @param zip - org -> compressed mapping
 * @param unzip - compressed -> org mapping
 * @return - size of compression
 */
template <typename T, class hash>
int compress(vector<T> org, unordered_map<T, int, hash> &zip,
             vector<T> &unzip) {
    sort(org.begin(), org.end());
    org.erase(unique(org.begin(), org.end()), org.end());
    int i = 0;
    for (auto &oi : org) {
        zip[oi] = i;
        unzip.push_back(i);
        i++;
    }
    return i;
}
]])

snippets.gnupdb = t(fmt [[
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>

template <typename T>
using oset = __gnu_pbds::tree<T, __gnu_pbds::null_type, std::less<T>,
	  __gnu_pbds::rb_tree_tag, __gnu_pbds::tree_order_statistics_node_update>;
]])

snippets.least_common_ancestor = t(fmt [[
struct LCA {

    int n;
    int timer;

    vt<vt<int>> ancestor;
    vt<int> tin, tout;

    LCA(int root, int n, vt<int> adj[])
        : n(n), ancestor(n, vt<int>(20, -2)), tin(n, -1),
          tout(n, -1) { // set super ancestor = -2
        dfs(root, -1, adj);
    }

    void dfs(int v, int p, vt<int> adj[]) {
        tin[v] = ++timer;
        EACH(node, adj[v]) {
            if (node != p) {
                FOR(i, 1, 20) {
                    ancestor[node][0] = v;
                    if (ancestor[node][i - 1] == -2)
                        break;
                    ancestor[node][i] = ancestor[ancestor[node][i - 1] ][i - 1];
                }
                dfs(node, v, adj);
            }
        }
        tout[v] = ++timer;
    }

    bool is_ancestor(int u, int v) {
        if (u == -2)
            return true;
        return tin[u] <= tin[v] and tout[u] >= tout[v];
    }

    int lca(int a, int b) {

        if (is_ancestor(a, b))
            return a;
        if (is_ancestor(b, a))
            return b;
        for (int i = 19; i >= 0; --i) {
            if (!is_ancestor(ancestor[a][i], b))
                a = ancestor[a][i];
        }
        return ancestor[a][0];
    }

    int kth_ancenstor(int node, int step) {
        if (step <= 0)
            return node;

        FOR(20)
        if (node != -2 and step & (1 << i)) {
            node = ancestor[node][i];
        }

        return node;
    }
};
]])

snippets.heavy_light_decomposition = t(fmt [[
template <typename T> struct HeavyLightDecomposition {
    vt<int> label, depth, chain, subtr_sz, par, bigchild;
    Segment_Tree<node<T>, update<T>> sgt;
    LCA lca;
    int label_time;

    HeavyLightDecomposition(int root, int n, vt<int> *adj, vt<T> &vals)
        : label(n), depth(n), chain(n), subtr_sz(n), par(n), bigchild(n, -2),
          sgt(n), lca(root, n, adj), label_time(0) {

        dfs_size(
            root, -1, 0,
            adj); // finds depth and subtree_sizes and largest child subtree
        dfs_labels(
            root, -1, adj,
            vals); // labels heavy chains consecutively for single segtree query

        FOR(n) chain[i] = i;
        dfs_chains(root, -1, adj); // finds top of each heavy chain
    };

    void dfs_labels(int v, int p, vt<int> adj[], vt<T> &vals) {
        label[v] = label_time++;

        update<T> upd(vals[v]);
        sgt.modify(label[v], upd);

        if (bigchild[v] != -2) {
            dfs_labels(bigchild[v], v, adj, vals);
        }

        EACH(node, adj[v]) {
            if (node != p and node != bigchild[v]) {
                dfs_labels(node, v, adj, vals);
            }
        }
    }

    void dfs_chains(int v, int p, vt<int> adj[]) {

        if (bigchild[v] != -2) {
            chain[bigchild[v] ] = chain[v];
        }

        EACH(node, adj[v]) {
            if (node != p) {
                dfs_chains(node, v, adj);
            }
        }
    }

    void dfs_size(int v, int p, int d, vt<int> adj[]) {
        subtr_sz[v] = 1;
        depth[v] = d;
        par[v] = p;

        int bigc = -2, bigv = -2;

        EACH(node, adj[v]) {
            if (node != p) {
                dfs_size(node, v, d + 1, adj);
                subtr_sz[v] += subtr_sz[node];

                if (subtr_sz[node] > bigv) {
                    bigc = node;
                    bigv = subtr_sz[node];
                }
            }
        }

        bigchild[v] = bigc;
    }

    node<T> query_chain(int v, int p, bool first_vert_chain, bool lazy) {

        node<T> res;

        while (depth[p] < depth[v]) {
            int top = chain[v]; // top of current chain;

            if (depth[top] <=
                depth[p]) { // resets to below lca if equal or above lca;
                int diff = depth[v] - depth[p];
                top = lca.kth_ancenstor(v, diff - 1);
            }

            node<T> query_res = sgt.query(label[top], label[v] + 1, lazy);

            if (first_vert_chain)
                res = node<T>::merge(res, query_res);
            else
                res = node<T>::merge(query_res, res);

            v = par[top];
        }

        return res;
    }

    node<T> query(int u, int v, bool lazy = false) {

        int lc = lca.lca(u, v);

        node<T> lca_res = sgt.query(label[lc], label[lc] + 1, lazy);

        node<T> left_res =
            node<T>::merge(query_chain(u, lc, true, lazy), lca_res);

        return node<T>::merge(left_res, query_chain(v, lc, false, lazy));
    }

    void modify(int v, update<T> &upd) { sgt.modify(label[v], upd); }

    void lazy_modify_chain(int v, int p, update<T> &upd) {

        while (depth[p] < depth[v]) {
            int top = chain[v]; // top of current chain;

            if (depth[top] <=
                depth[p]) { // resets to below lca if equal or above lca;
                int diff = depth[v] - depth[p];
                top = lca.kth_ancenstor(v, diff - 1);
            }

            sgt.lazy_modify(label[top], label[v] + 1, upd);

            v = par[top];
        }
    }

    void lazy_modify(int v, int u, update<T> &upd) {

        int lc = lca.lca(u, v);

        lazy_modify_chain(u, lc, upd);
        lazy_modify_chain(v, lc, upd);

        sgt.lazy_modify(label[lc], label[lc] + 1, upd);
    }
};
]])

snippets.centroid_decomposition = t(fmt [[
struct Centroid_Decomposition {
    int centroid_root, n;
    vt<int> parent, subtree;
    vt<vt<int>> centroid_tree;
    vt<bool> processed;

    Centroid_Decomposition(int n, vt<int> adj[])
        : n(n), parent(n), subtree(n), centroid_tree(n), processed(n, false) {
        centroid_root =
            get_centroid(0, -1, get_subtree_sizes(0, -1, adj) >> 1, adj);

        centroid_decomp(centroid_root, -1, adj);

        FOR(n) { // building centroid tree
            if (parent[i] != -1) {
                centroid_tree[i].pb(parent[i]);
                centroid_tree[parent[i] ].pb(i);
            }
        }
    }

    void centroid_decomp(int v, int p, vt<int> adj[]) {

        int subtree_sz_v = get_subtree_sizes(v, -1, adj);
        int centroid = get_centroid(v, -1, subtree_sz_v >> 1, adj);
        processed[centroid] = true;
        parent[centroid] = p;

        EACH(node, adj[centroid])
        if (!processed[node])
            centroid_decomp(node, centroid, adj);
    }

    int get_subtree_sizes(int v, int p, vt<int> adj[]) {

        subtree[v] = 1;

        EACH(node, adj[v]) {
            if (node != p and !processed[node]) {
                subtree[v] += get_subtree_sizes(node, v, adj);
            }
        }

        return subtree[v];
    }

    int get_centroid(int v, int p, int desired, vt<int> adj[]) {

        EACH(node, adj[v]) {
            if (!processed[node] && node != p && subtree[node] > desired) {
                return get_centroid(node, v, desired, adj);
            }
        }

        return v;
    }
};
]])

snippets.offset = t(fmt [[
template <class T> void offset(ll o, T& x) { x += o; }
template <class T> void offset(ll o, vt<T>& x)
{
	EACH(a, x)
		offset(o, a);
}
template <class T, size_t S> void offset(ll o, std::ar<T, S>& x)
{
	EACH(a, x)
		offset(o, a);
}
]])

snippets.vtfill = t(fmt [[
template <class T, class U> void vti(vt<T> &v, U x, size_t n) {
    v = vt<T>(n, x);
}
template <class T, class U> void vti(vt<T> &v, U x, size_t n, size_t m...) {
    v = vt<T>(n);
    EACH(a, v)
    vti(a, x, m);
}
]])

return snippets

