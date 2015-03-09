--神葬「杀人结界」
function c14700015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c14700015.target)
	e1:SetOperation(c14700015.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c14700015.descon)
	e2:SetCost(c14700015.descost)
	e2:SetTarget(c14700015.destg)
	e2:SetOperation(c14700015.desop)
	c:RegisterEffect(e2)
end
function c14700015.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c14700015.filter3(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c14700015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c14700015.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c14700015.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c14700015.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c14700015.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14700015,0))
	local g2=Duel.SelectTarget(tp,c14700015.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function c14700015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
	local ac=e:GetLabelObject()
	if tc==ac then tc=sc end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e)
		or ac:IsImmuneToEffect(e) or not ac:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_XYZ) then
		local og=ac:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(ac))
	end
end
function c14700015.cfilter1(c)
	return not (c:IsSetCard(0x147) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)))
end
function c14700015.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and not Duel.IsExistingMatchingCard(c14700015.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c14700015.cfilter(c)
	return c:IsSetCard(0x147) and c:IsAbleToRemoveAsCost()
end
function c14700015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c14700015.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c14700015.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14700015.filter(c)
	return c:IsDestructable()
end
function c14700015.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c14700015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14700015.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c14700015.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14700015.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end