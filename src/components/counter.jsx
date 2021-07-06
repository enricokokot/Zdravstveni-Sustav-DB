import React, { Component } from 'react';
// import {NavBar} from './navBar';

class Counter extends Component {
    componentDidUpdate(prevProps, prevState) {
        console.log('prevProps', prevProps);
        console.log('prevState', prevState);
        if (prevProps.counter.value !== this.props.counter.value) {
            // Ajax call and get new data from the server
        }
    }

    componentWillUnmount() {
        console.log('Counter - Unmount')
    }
    
    render() {
        console.log('Counters - Rendered')
        return (
            <React.Fragment>
                {/* <NavBar /> */}
                {/* {this.props.children} */}
                {/* <h4>{this.props.id}</h4> */}
                <span className={this.getBadgeClasses()}>{this.formatCount()}</span>
                <button 
                    onClick={() => this.props.onIncrement(this.props.counter)} 
                    className="btn btn-secondary btn-sm"
                >
                    Increment
                </button>
                <button 
                    onClick={() => this.props.onDelete(this.props.counter.id)}
                    className="btn btn-danger btn-sm m-2"
                >
                    Delete
                </button>
            </React.Fragment>
        );
    }

    getBadgeClasses() {
        let classes = "badge m-2 badge-";
        classes += (this.props.counter.value === 0) ? "warning" : "primary";
        return classes;
    }

    formatCount() {
        const {value: count} = this.props.counter;
        return count === 0 ? 'Zero' : count;
    }
}
/*
class Button extends React.Component {
    scream() {
      alert('AAAAAAAAHHH!!!!!');
    }
  
    render() {
      return (
        <button onClick={this.scream}>AAAAAH!</button>
      );
    }
}
*/
export default Counter;