--目隐团·不死少女·榎本贵音
function c19900029.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x199),aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c19900029.target)
	e1:SetOperation(c19900029.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c19900029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_HAND)
end
function c19900029.operation(e,tp,eg,ep,ev,re,r,rp)
	local g3=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_HAND,nil)
	if g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg3=g3:RandomSelect(tp,1)
		local sg=sg3:GetFirst()
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			if sg:IsType(TYPE_MONSTER) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
				e:GetHandler():RegisterEffect(e1)
			elseif sg:IsType(TYPE_SPELL) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
				e:GetHandler():RegisterEffect(e2)
			elseif sg:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
				local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				if g:GetCount()>0 then
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
		end
	end
end