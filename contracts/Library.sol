//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Library {
    struct Book {
        string ISBN;
        string title;
        uint256 year;
        string author;
    }
    mapping(string => Book) public books;

    event BookAdded(string indexed ISBN);
    event BookUpdate(string indexed ISBN);
    event BookDeleted(string indexed ISBN);

    address admin;


    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addBook(string memory _ISBN, string memory _title, uint256 _year, string memory _author) public onlyAdmin {
        require(bytes(books[_ISBN].ISBN).length == 0, "Book with this ISBN already exists"); // Memastikan ISBN unik
        books[_ISBN] = Book(_ISBN, _title, _year, _author);
    }
     function updateBook(string memory _ISBN, string memory _title, uint256 _year, string memory _author) public onlyAdmin {
        require(bytes(books[_ISBN].ISBN).length != 0, "Book with this ISBN does not exist"); // Memastikan buku ada
        books[_ISBN] = Book(_ISBN, _title, _year, _author);
    }
     function deleteBook(string memory _ISBN) public onlyAdmin {
        require(bytes(books[_ISBN].ISBN).length != 0, "Book with this ISBN does not exist"); // Memastikan buku ada
        delete books[_ISBN];
    }
     function getBook(string memory _ISBN) public view returns (string memory, string memory, uint256, string memory) {
        require(bytes(books[_ISBN].ISBN).length != 0, "Book with this ISBN does not exist"); // Memastikan buku ada
        return (books[_ISBN].ISBN, books[_ISBN].title, books[_ISBN].year, books[_ISBN].author);
    }
}