--月见的仪仗天使 圣枪
function c128802.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(128802,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c128802.target)
	e1:SetOperation(c128802.operation)
	c:RegisterEffect(e1)
end
function c128802.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128802,1))
end
function c128802.operation(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	for i=1,3 do t[i]=i end
	local tlv=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128802,1))
	local c=e:GetHandler()
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(128802,2),aux.Stringid(128802,3))
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		if op==0 then
			e1:SetValue(tlv)
		else e1:SetValue(-tlv) end
		c:RegisterEffect(e1)
	end
	local lv=c:GetLevel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c128802.matfilter,tp,LOCATION_GRAVE,0,nil,lv,e,tp)
	if mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c128802.matfilter,tp,LOCATION_GRAVE,0,1,1,nil,lv,e,tp)
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c128802.matfilter(c,lv,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x9fe) and c:GetLevel()==lv
end
