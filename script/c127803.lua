--伏行的分影 「时崎狂三」
function c127803.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c127803.spcon)
	c:RegisterEffect(e2)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c127803.atkcon)
	e1:SetTarget(c127803.eqtg)
	e1:SetOperation(c127803.eqop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c127803.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9fa)
end
function c127803.get_count(g)
	if g:GetCount()==0 then return 0 end
	local ret=0
	repeat
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		local ct1=g:GetCount()
		g:Remove(Card.IsCode,nil,tc:GetCode())
		local ct2=g:GetCount()
		local c=ct1-ct2+1
		if c>ret then ret=c end
	until g:GetCount()==0 or g:GetCount()<=ret
	return ret
end
function c127803.spcon(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c127803.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=c127803.get_count(g)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct==2 or ct==3
end
function c127803.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c127803.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9fa)
end
function c127803.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c127803.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c127803.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c127803.eqlimit(e,c)
	return e:GetOwner()==c
end
function c127803.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c127803.eqlimit)
		c:RegisterEffect(e1)
	end
end
