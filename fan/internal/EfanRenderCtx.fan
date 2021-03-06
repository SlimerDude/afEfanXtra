using concurrent::Actor
using afEfan::EfanErr

@NoDoc	// needs to be called from compiled pods
class EfanRenderCtx {
	private static const Str		localId		:= "efan.renderCtx"

	Str					renderId
	EfanRenderCtx?		parent		{ private set }
	EfanComponent		rendering	{ private set }
	Func? 				bodyFunc	{ private set }
	private [Str:Obj?]?	_vars		{ private set }
	private	StrBuf?		_renderBuf

	private new _makeDup(EfanRenderCtx dup) {
		this.renderId	= dup.renderId
		this.parent		= null	// parent should only be set by runInCtx()
		this.rendering	= dup.rendering
		this.bodyFunc	= dup.bodyFunc
		this._vars		= dup._vars
		this._renderBuf	= null
	}
	
	internal new make(EfanComponent rendering, Func? bodyFunc) {
		this.renderId	= rendering.componentId
		this.rendering	= rendering
		this.bodyFunc	= bodyFunc
	}

	Obj? runInCtx(|EfanRenderCtx -> Obj?| func) {
		if (this.parent != null)
			throw Err("Component RenderCtx already parented: $renderId -> $parent.renderId")
		
		this.parent = peek(false)	// false 'cos we may be the first!
		Actor.locals[localId] = this
		try	  				return func.call(this)
		catch (EfanErr err)	throw err
		catch (Err err)		throw rendering.efanMeta.efanRuntimeErr(err)
		finally {
			if (this.parent == null)
				Actor.locals.remove(localId)
			else
				Actor.locals[localId] = this.parent
			this.parent = null
		}
	}

	StrBuf renderBuf() {
		if (_renderBuf == null)
			_renderBuf = StrBuf(rendering.efanMeta.templateSrc.size)
		return _renderBuf
	}

	Uri path() {
		(parent?.path ?: `/`).plusSlash.plusName(renderId)
	}
	
	EfanRenderCtx? bodyDup() {
		daddy := this.parent
		return daddy == null ? null
			// oddly enough, bodyFunc is set on the inner obj, not the parent  
			: daddy.dup {
				it.renderId += "(Body)"
			}
	}
	
	private EfanRenderCtx dup() {
		EfanRenderCtx(this)
	}

	Void setVar(Str name, Obj? value) {
		if (_vars == null)
			if (value == null) return; else _vars = Str:Obj?[:]
		_vars[name] = value
	}
	
	Obj? getVar(Str name) {
		_vars?.get(name)
	}

	Bool hasVar(Str name) {
		_vars == null ? false : _vars.containsKey(name)
	}
	
	static EfanRenderCtx? peek(Bool checked := true) {
		Actor.locals[localId] ?: (checked ? throw Err("Could not find EfanRenderCtx in Actor.locals()") : null)		
	}
	
	override Str toStr() { rendering.componentId }
}
