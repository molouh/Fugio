#ifndef PREVIEW_H
#define PREVIEW_H

#include "opengl_includes.h"

#include <QOpenGLWidget>

#include <fugio/node_interface.h>
#include <fugio/render_interface.h>

class PreviewNode;

class Preview : public QOpenGLWidget
{
	Q_OBJECT

public:
	explicit Preview( QWeakPointer<fugio::NodeInterface> pNode, QWidget *pParent = Q_NULLPTR );

	virtual ~Preview( void );

	// QOpenGLWidget interface
protected:
	virtual void initializeGL() Q_DECL_OVERRIDE;
	virtual void resizeGL(int w, int h) Q_DECL_OVERRIDE;
	virtual void paintGL() Q_DECL_OVERRIDE;

private:
	QWeakPointer<fugio::NodeInterface>	 mNode;
};

#endif // PREVIEW_H
