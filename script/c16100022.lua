--超电磁炮
function c16100022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c16100022.target)
	e1:SetOperation(c16100022.activate)
	c:RegisterEffect(e1)
end
function c16100022.filter(c,tp)
	local seq=c:GetSequence()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1161)
		and (Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)~=nil or Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)~=nil)
end
function c16100022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16100022.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16100022.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g0=Duel.SelectTarget(tp,c16100022.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g0:GetFirst()
	local seq=tc:GetSequence()
	local g=Group.CreateGroup()
	local dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if dc then g:AddCard(dc) end
	dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if dc then g:AddCard(dc) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16100022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	Duel.Destroy(g,REASON_EFFECT)
end