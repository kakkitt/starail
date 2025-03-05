import 'package:flutter/material.dart';
import 'dart:ui';

class FancyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? accentColor;

  const FancyTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.autofocus = false,
    this.accentColor,
  }) : super(key: key);

  @override
  State<FancyTextField> createState() => _FancyTextFieldState();
}

class _FancyTextFieldState extends State<FancyTextField> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_onFocusChange);
    }
  }
  
  void _onFocusChange() {
    if (widget.focusNode != null) {
      setState(() {
        _isFocused = widget.focusNode!.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? Theme.of(context).primaryColor;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isFocused ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: _isFocused 
                ? accentColor.withOpacity(0.8) 
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused 
                  ? accentColor.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                onSubmitted: widget.onSubmitted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                cursorColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FancyDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T?) onChanged;
  final Color? accentColor;

  const FancyDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.accentColor,
  }) : super(key: key);

  @override
  State<FancyDropdown<T>> createState() => _FancyDropdownState<T>();
}

class _FancyDropdownState<T> extends State<FancyDropdown<T>> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? Theme.of(context).primaryColor;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isOpen ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: _isOpen 
                ? accentColor.withOpacity(0.8) 
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isOpen 
                  ? accentColor.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  hint: Text(
                    widget.hintText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                  value: widget.value,
                  items: widget.items,
                  onChanged: (value) {
                    widget.onChanged(value);
                    setState(() {
                      _isOpen = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isOpen = true;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  dropdownColor: Colors.black.withOpacity(0.7),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  isExpanded: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}