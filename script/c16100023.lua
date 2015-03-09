--电击
function c16100023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c16100023.target)
	e1:SetOperation(c16100023.activate)
	c:RegisterEffect(e1)
end
function c16100023.filter(c,tp)
	local seq=c:GetSequence()
	local dt=0
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)~=nil then dt=dt+1 end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)~=nil then dt=dt+1 end
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1161)
		and dt>0 and Duel.IsPlayerCanDraw(tp,dt)
end
function c16100023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16100023.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16100023.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g0=Duel.SelectTarget(tp,c16100023.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g0:GetFirst()
	local seq=tc:GetSequence()
	local dt=0
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)~=nil then dt=dt+1 end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)~=nil then dt=dt+1 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dt)
end
function c16100023.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	local dt=0
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)~=nil then dt=dt+1 end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)~=nil then dt=dt+1 end
	Duel.Draw(tp,dt,REASON_EFFECT)
end