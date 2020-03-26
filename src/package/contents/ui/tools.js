function listModelSort(listModel, compareFunction) {
    let indexes = [ ...Array(listModel.count).keys() ]
    indexes.sort( (a, b) => compareFunction( listModel.get(a), listModel.get(b) ) )
    let sorted = 0
    while ( sorted < indexes.length && sorted === indexes[sorted] ) sorted++
    if ( sorted === indexes.length ) return
    for ( let i = sorted; i < indexes.length; i++ ) {
        listModel.move( indexes[i], listModel.count - 1, 1 )
        listModel.insert( indexes[i], { } )
    }
    listModel.remove( sorted, indexes.length - sorted )
}
