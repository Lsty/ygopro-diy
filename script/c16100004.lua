--女仆装 御坂美琴
function c16100004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetCondition(c16100004.spcon)
	e1:SetOperation(c16100004.spop)
	c:RegisterEffect(e1)
	--darw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c16100004.drtg)
	e1:SetOperation(c16100004.drop)
	c:RegisterEffect(e1)
end
function c16100004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and ((Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil)))
end
function c16100004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local p=g:GetFirst():GetControler()
	if p==1-tp then e:SetTargetRange(POS_FACEUP_ATTACK,1) end
	Duel.Release(g,REASON_COST)
end
function c16100004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetTurnPlayer()==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16100004.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end