// from https://gist.github.com/erica/72be2ffe76a569376469c2f2110aee9c
// @discardableResult to be added
// @noescape needs to move to type annotation
// needs to add _ for item
public func with<T>(item: T, @noescape update: (inout T) throws -> Void) rethrows -> T {
    var this = item; try update(&this); return this
}
