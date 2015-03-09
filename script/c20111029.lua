--克洛斯贝尔自治州
function c20111029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c20111029.drcon)
	e2:SetTarget(c20111029.drtg)
	e2:SetOperation(c20111029.drop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c20111029.indtg)
	e3:SetValue(c20111029.indval)
	c:RegisterEffect(e3)
end
function c20111029.cfilter(c)
	return c:IsSetCard(0x929) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c20111029.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c20111029.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c20111029.filter(c)
	return c:IsSetCard(0x930) and c:GetCode()~=20111029 and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c20111029.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c20111029.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20111029.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c20111029.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,1,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c20111029.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x930) and c:GetCode()~=20111029 and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c20111029.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
