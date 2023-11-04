// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/INFTEdu.sol";

contract Perpustakaan {
    struct Book {
        string judul;
        uint256 tahun;
        string penulis;
    }

    struct BookInfo {
        string isbn;
        uint256 index;
    }

    mapping(string => Book) private books;
    mapping(string => BookInfo) private bookInfo;
    address private owner;

    event BookAdded(string isbn, uint256 tokenId);
    event BookUpdated(string isbn);
    event BookDeleted(string isbn);

    modifier onlyOwner() {
        require(msg.sender == owner, "Hanya owner yang dapat mengakses");
        _;
    }

    INFTEdu public nft;

    constructor(address _nft) {
        owner = msg.sender;
        nft = INFTEdu(_nft);
    }

    function addBook(string memory isbn, string memory judul, uint256 tahun, string memory penulis, string memory token_uri) public {
        require(!isBookExists(isbn), "Buku dengan nomor ISBN sudah");
        books[isbn] = Book(judul, tahun, penulis);
        bookInfo[isbn] = BookInfo(isbn, isbnList.length);
        isbnList.push(isbn);

        uint256 tokenId = nft.awardItem(msg.sender, token_uri);

        emit BookAdded(isbn, tokenId);
    }

    function updateBook(string memory isbn, string memory judul2, uint256 tahun2, string memory penulis2) public onlyOwner {
        require(isBookExists(isbn), "Buku dengan ISBN yang dicari tidak ada");
        books[isbn] = Book(judul2, tahun2, penulis2);
        emit BookUpdated(isbn);
    }

    function deleteBook(string memory isbn) public onlyOwner {
        require(isBookExists(isbn), "Buku dengan ISBN yang dicari tidak ada");
        uint256 indexToDelete = bookInfo[isbn].index;
        require(indexToDelete < isbnList.length, "Terjadi Kesalahan");
        
        // Pindahkan ISBN terakhir dalam daftar ke posisi terhapus, lalu perkecil ukuran daftarnya.
        string memory lastIsbn = isbnList[isbnList.length - 1];
        isbnList[indexToDelete] = lastIsbn;
        bookInfo[lastIsbn].index = indexToDelete;
        isbnList.pop();
        
        // Hapus buku dan BookInfo
        delete books[isbn];
        delete bookInfo[isbn];
        emit BookDeleted(isbn);
    }

    function getBookInfo(string memory isbn) public view returns (string memory judul, uint256 tahun, string memory penulis) {
        require(isBookExists(isbn), "Buku dengan ISBN yang dicari tidak ada");
        Book storage book = books[isbn];
        return (book.judul, book.tahun, book.penulis);
    }

    function isBookExists(string memory isbn) public view returns (bool) {
        return bytes(books[isbn].judul).length != 0;
    }

    function getAllISBNs() public view returns (string[] memory) {
        return isbnList;
    }
    
    string[] private isbnList;
}
