--接受的思念
function c12400026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12400026.target)
	e1:SetOperation(c12400026.activate)
	c:RegisterEffect(e1)
end
function c12400026.cfilter(c)
	return c:IsSetCard(0xabd)
end
function c12400026.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c12400026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		local sh=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:GetHandler():IsLocation(LOCATION_HAND) then sh=sh-1 end
		return sh>1 and Duel.IsExistingTarget(c12400026.cfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingTarget(c12400026.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c12400026.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP,g,2,0,0)
end
function c12400026.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingTarget(c12400026.filter,tp,LOCATION_MZONE,0,1,nil) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local cg=Duel.SelectTarget(tp,c12400026.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=cg:GetFirst()
	local tg=sg:GetFirst()
	while tg do
		if Duel.Equip(tp,tg,c) then
		--Add Equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c12400026.eqlimit)
			e1:SetLabelObject(c)
			tg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_SET_CONTROL)
			e2:SetValue(tp)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			tg:RegisterEffect(e2)
		end
		tg=sg:GetNext()
	end
end
function c12400026.eqlimit(e,c)
	return c==e:GetLabelObject()
end
