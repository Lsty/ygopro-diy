--潜伏的混沌 奈亚拉托提普
function c32100015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c32100015.xyzfilter,7,2)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c32100015.target)
	e1:SetOperation(c32100015.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c32100015.cost)
	e2:SetTarget(c32100015.target1)
	e2:SetOperation(c32100015.operation1)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DICE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c32100015.dscon)
	e3:SetTarget(c32100015.mttg)
	e3:SetOperation(c32100015.mtop)
	c:RegisterEffect(e3)
end
function c32100015.xyzfilter(c)
	return c:GetTextAttack()==-2 and c:GetTextDefence()==-2
end
function c32100015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c32100015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local dice=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(dice*800)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(dice*800)
		c:RegisterEffect(e2)
	end
end
function c32100015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c32100015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
end
function c32100015.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c32100015.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local c=e:GetHandler()
	local d1,d2=Duel.TossDice(tp,2)
	if d2<d1 then d1,d2=d2,d1 end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(d1*-300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if d1==d2 then
		if d1==1 or d1==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local tc=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
			tg=tc:GetFirst()
			Duel.GetControl(tg,tp)
		elseif d1==3 or d1==4 then
			local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if g2:GetCount()==0 then return end
			Duel.ConfirmCards(tp,g2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag1=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(ag1,tp,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c32100015.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c32100015.dscon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c32100015.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c32100015.mtfilter(c,dice)
	return c:IsLevelBelow(dice) and c:IsType(TYPE_MONSTER)
end
function c32100015.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local dice=Duel.TossDice(tp,1)
		local g=Duel.SelectMatchingCard(tp,c32100015.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,dice)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end