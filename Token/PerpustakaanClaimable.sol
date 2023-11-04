// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/ITestToken.sol";

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

    event BookAdded(string isbn);
    event BookUpdated(string isbn);
    event BookDeleted(string isbn);
    event ClaimReward(uint256 tokenId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Hanya owner yang dapat mengakses");
        _;
    }

    ITestToken public token;

    mapping(address => uint256) public userClaimables;

    constructor(address _token) {
        owner = msg.sender;
        token = ITestToken(_token);
    }

    function claimReward() public {
        require(userClaimables[msg.sender] > 0, "User tidak punya reward untuk diclaim");
        userClaimables[msg.sender] = userClaimables[msg.sender] - 1;
        token.awardToken(msg.sender, 1_000_000_000_000_000_000);
    }

    function addBook(string memory isbn, string memory judul, uint256 tahun, string memory penulis) public {
        require(!isBookExists(isbn), "Buku dengan nomor ISBN sudah");
        books[isbn] = Book(judul, tahun, penulis);
        bookInfo[isbn] = BookInfo(isbn, isbnList.length);
        isbnList.push(isbn);

        userClaimables[msg.sender] = userClaimables[msg.sender] + 1;

        emit BookAdded(isbn);
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
