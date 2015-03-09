--梦日记-附窗子
function c75500007.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c75500007.target)
	e1:SetOperation(c75500007.operation)
	c:RegisterEffect(e1)
end
function c75500007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	e:SetLabel(res)
end
function c75500007.sumfilter(c,e,tp)
	return c:IsSetCard(0x755) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75500007.operation(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local ct=g:GetCount()
	if ct>0 then
		local sg=g:GetFirst()
		if (res==0 and sg:IsType(TYPE_MONSTER)) or (res==1 and sg:IsType(TYPE_SPELL)) or (res==2 and sg:IsType(TYPE_TRAP)) then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75500007.sumfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75500007,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c75500007.sumfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end