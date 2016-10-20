--The Future Gear Kid
function c99199028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199028.splimit)
	e2:SetCondition(c99199028.splimcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199028,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,99199028)
	e3:SetTarget(c99199028.sptg)
	e3:SetOperation(c99199028.spop)
	c:RegisterEffect(e3)
	--special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199028,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c99199028.target)
	e4:SetOperation(c99199028.operation)
	c:RegisterEffect(e4)
	--destroy and set
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c99199028.destg)
	e5:SetOperation(c99199028.desop)
	c:RegisterEffect(e5)
end
function c99199028.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199028.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Group.CreateGroup()
		for i=0,4 do
			local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
			if tc and tc:IsFaceup() and tc:IsSetCard(0xff15) and tc:IsType(TYPE_XYZ) then
				g:Merge(tc:GetOverlayGroup())
			end
		end
		if g:GetCount()==0 then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199028.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsSetCard(0xff15) and tc:IsType(TYPE_XYZ) then
			g:Merge(tc:GetOverlayGroup())
		end
	end
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99199028.specfilter(c,e,tp)
	return c:IsCode(99199028) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99199028.specfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99199028.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c99199028.specfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	tc=g:GetNext()
	if ft>1 and tc and Duel.SelectYesNo(tp,aux.Stringid(99199028,2)) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c99199028.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c99199028.setfilter(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c99199028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c99199028.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c99199028.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c99199028.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99199028.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99199028.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c99199028.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end