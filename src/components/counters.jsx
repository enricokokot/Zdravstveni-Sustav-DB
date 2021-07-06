import React, { Component } from 'react';
import Counter from './counter';

class Counters extends Component {
    render() {
        console.log('Counters - Rendered')
        const { onReset, counters, onDelete, onIncrement } = this.props;
        
        return ( 
            <div className="bro">
                <button 
                    onClick={onReset}
                    className="btn btn-primary btn-sm m-2"
                >
                    Reset
                </button>
                { counters.map(counter => 
                    <Counter 
                        key={counter.id}   // privatan prop...
                        onDelete={onDelete}
                        onIncrement={onIncrement}
                        // value={counters.value} 
                        // id={counters.id}    // ...zato imamo dupliće
                        counter={counter}
                    >
                        {/* <h4>Counter #{counters.id}</h4> */}
                    </Counter>
                )}
            </div> 
        );
    }
}
 
export default Counters;