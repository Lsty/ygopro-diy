--★Chariot
function c20121153.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c20121153.con)
	e1:SetTarget(c20121153.destg)
	e1:SetOperation(c20121153.desop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c20121153.destg1)
	e2:SetOperation(c20121153.desop1)
	c:RegisterEffect(e2)
end
function c20121153.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x777)
end
function c20121153.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20121153.confilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c20121153.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x777) and c:IsDestructable()
		and Duel.IsExistingTarget(c20121153.desfilter2,0,0,LOCATION_ONFIELD,1,c)
end
function c20121153.desfilter2(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c20121153.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c20121153.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c20121153.desfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c20121153.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c20121153.desfilter2,tp,0,LOCATION_ONFIELD,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c20121153.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c20121153.desfilter1(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c20121153.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c20121153.desfilter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20121153.desfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c20121153.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end