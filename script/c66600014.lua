--星花之魔姬
function c66600014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c66600014.xyzfilter,4,3)
	c:EnableReviveLimit()
	--DESTROY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c66600014.cost)
	e1:SetCondition(c66600014.con)
	e1:SetTarget(c66600014.tg)
	e1:SetOperation(c66600014.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c66600014.ccost)
	e2:SetTarget(c66600014.target)
	e2:SetOperation(c66600014.operation)
	c:RegisterEffect(e2)
end
function c66600014.xyzfilter(c)
	return c:IsSetCard(0x666) or c:IsRace(RACE_PLANT)
end
function c66600014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600014)==0 end
	Duel.RegisterFlagEffect(tp,66600014,RESET_PHASE+PHASE_END,0,1)
end
function c66600014.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c66600014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0,nil)
end
function c66600014.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c66600014.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,166600014)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.RegisterFlagEffect(tp,166600014,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c66600014.dfilter(c,atk)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsAttackBelow(atk)
end
function c66600014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c66600014.filter(chkc) and chkc:GetLocation()==LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(c66600014.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66600014.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local dg=Duel.GetMatchingGroup(c66600014.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if dg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,1,0,0)
	end
end
function c66600014.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,c66600014.dfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
		Duel.SendtoGrave(dg,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
	end
end