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

console.log('tampilkan object: ', object1);

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
