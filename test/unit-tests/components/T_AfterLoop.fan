
@NoDoc 
const mixin T_AfterLoop : EfanComponent {
	abstract Int? loopy
	
	Void initRender() {
		loopy = 1
	}
	
	Bool afterRender() {
		loopy++ == 3
	}
}

