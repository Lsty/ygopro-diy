--时符·无差别伤害
function c98700017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c98700017.condition)
	e1:SetCost(c98700017.cost)
	e1:SetTarget(c98700017.target)
	e1:SetOperation(c98700017.activate)
	c:RegisterEffect(e1)
end
function c98700017.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700017)==0 end
	Duel.RegisterFlagEffect(tp,98700017,RESET_PHASE+PHASE_END,0,1)
end
function c98700017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetCurrentChain()<1 or Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,800)
end
function c98700017.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	Duel.Damage(tp,800,REASON_EFFECT)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	if ct>1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local atk=tc:GetBaseAttack()/2
			if Duel.Destroy(tc,REASON_EFFECT)>0 then
				Duel.Damage(1-tp,atk,REASON_EFFECT)
				Duel.Damage(tp,atk,REASON_EFFECT)
			end
		end
	end
end