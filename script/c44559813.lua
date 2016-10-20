--Chang E, Descendant of the Nirvana
function c44559813.initial_effect(c)
	c:SetUniqueOnField(1,0,44559813)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44559813.spcon)
	e1:SetOperation(c44559813.spop)
	c:RegisterEffect(e1)
	--recover LP
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c44559813.rectg)
	e2:SetOperation(c44559813.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--effect indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetCountLimit(1,44559813)
	e5:SetValue(c44559813.valcon1)
	c:RegisterEffect(e5)
	--battle indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetCountLimit(1,44559813)
	e6:SetValue(c44559813.valcon2)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(44559813,0))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c44559813.discon)
	e7:SetTarget(c44559813.distg)
	e7:SetOperation(c44559813.disop)
	c:RegisterEffect(e7)
end
function c44559813.spcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and not c:IsPublic()
end
function c44559813.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c44559813.spcfilter,tp,LOCATION_HAND,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=2
end
function c44559813.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local hg=Duel.GetMatchingGroup(c44559813.spcfilter,tp,LOCATION_HAND,0,c)
	local rg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=hg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		rg:AddCard(tc)
		hg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
end
function c44559813.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832)
end
function c44559813.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c44559813.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c44559813.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c44559813.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
function c44559813.valcon1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c44559813.valcon2(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c44559813.discon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c44559813.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c44559813.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	end
end