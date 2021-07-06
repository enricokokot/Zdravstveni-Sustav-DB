import React, { Component } from 'react';

// Stateless Functional Component
// we have to pass props as an argument in order to use them
// we can't use this.
const NavBar = ({ totalCounters }) => {
    console.log('NavBar - Rendered');

    return ( 
        <nav className="navbar navbar-light bg-light">
        <div className="container-fluid">
            <a className="navbar-brand" href="#">
                Navbar 
                <span className="badge badge-pill badge-secondary">
                    {totalCounters}
                </span>
            </a>
        </div>
    </nav>
    );
};
 
export default NavBar;