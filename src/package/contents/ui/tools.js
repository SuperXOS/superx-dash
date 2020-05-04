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

function insertSorted(insertedObject,arr) {
    let isLast=true;
    if(arr.length===0)
        arr.push(insertedObject)
    else {
        for (let i = 0, len = arr.length; i < len; i++) {
            if (insertedObject.name < arr[i].name) {
                isLast = false;
                arr.splice(i, 0, insertedObject);
                break;
            }
        }
        if(isLast){
            arr.push(insertedObject);//add to the end
        }
    }
    return arr;
}
