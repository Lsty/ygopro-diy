--最高女仆长 苏妃雅
function c3030320.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x3ad),1)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20663556,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c3030320.damtg)
	e1:SetOperation(c3030320.damop)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e3:SetValue(c3030320.value)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,3030320)
	e1:SetTarget(c3030320.drtg)
	e1:SetOperation(c3030320.drop)
	c:RegisterEffect(e1)
end
function c3030320.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*400)
end
function c3030320.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*400,REASON_EFFECT)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c3030320.tfilter(c,e,tp)
	return c:IsFacedown() and c:IsDestructable()
end
function c3030320.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local s=Duel.GetMatchingGroupCount(c3030320.tfilter,tp,0,LOCATION_SZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c3030320.tfilter,tp,0,LOCATION_SZONE,1,c) and Duel.IsPlayerCanDraw(1-tp,s)  end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,LOCATION_DECK)
end
function c3030320.drop(e,tp,eg,ep,ev,re,r,rp)
	local s=Duel.GetMatchingGroupCount(c3030320.tfilter,tp,0,LOCATION_SZONE,nil)
	local sg=Duel.GetMatchingGroup(c3030320.tfilter,tp,0,LOCATION_SZONE,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	local sg=Duel.GetDecktopGroup(1-tp,s)
	local tc=sg:GetFirst()
	Duel.Draw(1-tp,s,REASON_EFFECT)
end
function c3030320.value(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end