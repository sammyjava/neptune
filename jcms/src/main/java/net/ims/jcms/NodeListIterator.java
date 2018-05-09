package net.ims.jcms;

import java.util.ListIterator;

/**
 * A ListIterator designed to be used with NodeList.  Includes nextNode() method to return a Node directly.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class NodeListIterator implements ListIterator {

  ListIterator<Node> li;

  NodeListIterator(ListIterator<Node> li) {
    this.li = li;
  }

  /* Return a Node already cast. */
  public Node nextNode() {
    return (Node)li.next();
  }

  /* The rest of these methods simply return the superinterface methods */

  public boolean hasNext() {
    return li.hasNext();
  }
  
  public boolean hasPrevious() {
    return li.hasPrevious();
  }
  
  public Object next() {
    return li.next();
  }
  
  public Object previous() {
    return li.previous();
  }
  
  public void add(Object o) {
    li.add((Node)o);
  }

  public void set(Object o) {
    li.set((Node)o);
  }

  public void remove() {
    li.remove();
  }

  public int nextIndex() {
    return li.nextIndex();
  }
  
  public int previousIndex() {
    return li.previousIndex();
  }
  
}



