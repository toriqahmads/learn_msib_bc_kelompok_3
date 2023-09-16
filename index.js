// tes index.js
// perubahan dari github secara langsung
/**
 * komentar
 * panjang
 * lebih dari 1 line
 */

// variable adalah tempat penampungan suatu nilai
// variable nilainya dapat diubah
// nama variable tidak boleh diawali dengan angka dan tidak boleh mengandung spasi
// keyword untuk membuat variable yaitu let nama_variablenya atau var nama_variablenya
// namun yg akan kita pakai yaitu keyword let
let nama = 'Toriq Ahmad Salam';
var nama_2;

console.log('variable sebelum ada nilainya: ', nama, nama_2);

nama = 'Toriq Ahmad';

console.log('variable setelah ada nilainya: ', nama, nama_2);

// konstanta adalah tempat penampungan suatu yg nilainya tetap ketika pertama kali dibuat
// nilai konstanta tidak dapat diubah
// keyword untuk membuat konstanta yaitu const nama_konstantanya
const PI = 3.14;
console.log('konstanta PI bernilai: ', PI);
// ini akan terjadi error
// PI = 10;
// console.log('konstanta PI setelah diubah bernilai: ', PI);

// type data di Javasript terbagi menjadi 2
// type data primitive: string, character, boolean, number (integer, double, float)
// string
let string1 = "ini string";
// character
let character1 = 'A';
// boolean
let boolean = false; // true
// number
let angka = 1; // 1.1 1.2

// type data : object dan array
// object adalah type data yg memiliki key dan value dan dapat menampung berbagai type data dalam 1 waktu
let object1 = {
    key: 'key',
    nomor: 1,
    object_anak: {
        key_anak: 'key anak',
        nomor_anak: 'nomor anak'
    }
}

console.log('tampilkan object: ', object1, object1.nomor, object1["key"], object1.object_anak.nomor_anak);

// array adalah type data yg memiliki beberapa data dgn type yg berbeda-beda.
let array1 = ["A", "AB", 3, 4.5, true, false, { "key": "value" }, ["array dalam array"]];
    // index   0    1    2   3    4     5, ...
console.log("tampilkan array: ", array1);
console.log("array index 5 adalah: ", array1[6]["key"]);
console.log("array di dalam di array: ", array1[7][0]);

// konditional statement
// konditional statement ini digunakan untuk melakukan pengecekan nilai, dan menentukan statement selanjutnya mana yg akan dieksekusi
// terdapat 2 jenis konditional statement, yaitu if else, dan switch case

// if
const nilai_saya = 60;
let grade;
if (nilai_saya >= 70) {
    console.log('nilai saya lebih besar dari 70, yaitu ', nilai_saya);
}

// if else if else
if (nilai_saya >= 90) {
    grade = 'A';
} else if (nilai_saya >= 70) {
    grade = 'B';
} else {
    grade = 'C';
}

console.log('grade saya yaitu ', grade);

// if else
if (nilai_saya >= 90) {
    grade = 'A';
} else {
    grade = 'B';
}

console.log('grade saya yaitu ', grade);


// switch case
const umur = 25;
switch (umur) {
    case 25:
        console.log('tua');
        break;
    case 20:
        console.log('muda');
        break;
    default:
        console.log('anak-anak');
        break;
}


// perulangan
// perulangan di javascript digunakan untuk mengeksekusi statement program di dalam block perulangan secara berulang-ulang
// ada beberapa perulangan, umumnya
// for loop, while loop, do while loop

// for loop
for (i = 0; i < 10; i++) {
    // block perulangan
    console.log('ini perulangan for loop ke: ', i);
}


// while loop
let j = 0;
while (j <= 5) {
    // block perulangan
    console.log('ini perulangan while ke: ', j);
    j++;
}

// do while
let k = 5;
do {
    // block perulangan
    console.log('ini perulangan do while ke: ', k);
    k--;
} while (k >= 1);


// function adalah fungsi yg memiliki statement di dalam block fungsinya yg akan dieksekusi ketika fungsi tersebut dipanggil
// fungsi pada umumnya

// pendefinisian fungsi
function hitungPanjangString(target) {
    // block fungsi
    const panjang_string = target.length;
    console.log('panjang string di fungsi hitungPanjangString adalah: ', panjang_string);

    return panjang_string;
}

// pemanggilan
hitungPanjangString("test 1 2 3");

function tanpaParameter() {
    console.log('ini fungsi tanpa parameter');
}

tanpaParameter();

function tampilkanStringJikaPanjangLebihDari(target, maksimal_panjang) {
    const panjang_string = 0;
    const panjang_string_di_fungsi_tampilkan = hitungPanjangString(target);
    console.log('nilai variable panjang_string_di_fungsi_tampilkan di block fungsi tampilkanStringJikaPanjangLebihDari adalah: ', panjang_string_di_fungsi_tampilkan);
    console.log('nilai variable panjang_string di block fungsi tampilkanStringJikaPanjangLebihDari adalah: ', panjang_string);

    if (panjang_string <= maksimal_panjang) {
        console.log("panjang string memenuhi maksimal panjang: ", maksimal_panjang);
    } else {
        console.log("panjang string melebihi panjang maksimal: ", maksimal_panjang);
    }
}

tampilkanStringJikaPanjangLebihDari("ini test", 10);