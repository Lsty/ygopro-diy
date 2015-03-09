--妄执剑「阿修罗之血」
function c81700180.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x817),2,true)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81700180,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c81700180.descon)
	e2:SetTarget(c81700180.destg)
	e2:SetOperation(c81700180.desop)
	c:RegisterEffect(e2)
	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81700180,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c81700180.condition2)
	e3:SetTarget(c81700180.target2)
	e3:SetOperation(c81700180.activate2)
	c:RegisterEffect(e3)
end
function c81700180.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c81700180.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(Duel.GetMatchingGroupCount(c81700180.filter,tp,LOCATION_MZONE,0,nil)*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetMatchingGroupCount(c81700180.filter,tp,LOCATION_MZONE,0,nil)*500)
end
function c81700180.filter(c)
	return c:IsSetCard(0x817) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c81700180.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c81700180.filter,tp,LOCATION_MZONE,0,nil)*500
	if Duel.Damage(p,dam,REASON_EFFECT)~=0 and c:IsAttackPos() then
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
	end
end
function c81700180.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE
end
function c81700180.filter2(c)
	return c:IsSetCard(0x817) and c:IsSummonable(true,nil)
end
function c81700180.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not e:GetHandler():IsStatus(STATUS_CHAINING) then
			local ct=Duel.GetMatchingGroupCount(c81700180.filter2,tp,LOCATION_HAND,0,nil)
			e:SetLabel(ct)
			return ct>0
		else return e:GetLabel()>0 end
	end
	e:SetLabel(e:GetLabel()-1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81700180.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81700180.filter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end