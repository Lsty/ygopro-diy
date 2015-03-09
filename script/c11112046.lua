--怪物猎人 眠鸟
function c11112046.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77205367,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11112046.target)
	e1:SetOperation(c11112046.operation)
	c:RegisterEffect(e1)
end
function c11112046.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then
		local a=Duel.GetAttacker()
		local at=Duel.GetAttackTarget()
		return ((a==c and at) or (at==c)) and a:IsPosition(POS_FACEUP_ATTACK) and at:IsPosition(POS_FACEUP_ATTACK)
			and not e:GetHandler():IsStatus(STATUS_CHAINING)
	end
	local bc=c:GetBattleTarget()
    Duel.SetTargetCard(bc)
	local g=Group.FromCards(c,bc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end	
function c11112046.pfilter(c,e)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsRelateToEffect(e)
end
function c11112046.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if g:FilterCount(c11112046.pfilter,nil,e)>0 then
	    Duel.DiscardDeck(tp,1,REASON_EFFECT)
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
	g:DeleteGroup()
end