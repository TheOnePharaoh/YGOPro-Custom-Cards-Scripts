--Evil HERO Brightness
function c888000016.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c888000016.atkup)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c888000016.splimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000016,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetLabel(0)
	e3:SetCondition(c888000016.thcon)
	e3:SetTarget(c888000016.thtg)
	e3:SetOperation(c888000016.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
end
c888000016.dark_calling=true
function c888000016.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000016.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8)
end
function c888000016.atkup(e,c)
	return Duel.GetMatchingGroupCount(c888000016.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*300
end
function c888000016.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToHand()
end
function c888000016.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(m)
end
function c888000016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c888000016.filter(c)
	return (c:IsSetCard(0x46) or c:IsCode(12071500)) and c:IsAbleToHand()
end
function c888000016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mg=Duel.GetMatchingGroup(c888000016.filter1,tp,LOCATION_REMOVED,0,nil,e)
		return Duel.IsExistingMatchingCard(c888000016.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) 
		or Duel.IsExistingMatchingCard(c888000016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(888000016,0))
	if Duel.IsExistingMatchingCard(c888000016.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) 
		and Duel.IsExistingMatchingCard(c888000016.filter1,tp,LOCATION_REMOVED,0,1,nil,e)
		and Duel.IsExistingMatchingCard(c888000016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(888000016,1),aux.Stringid(888000016,2),aux.Stringid(888000016,3))
	elseif Duel.IsExistingMatchingCard(c888000016.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) 
		and Duel.IsExistingMatchingCard(c888000016.filter1,tp,LOCATION_REMOVED,0,1,nil,e) then
		Duel.SelectOption(tp,aux.Stringid(888000016,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(888000016,2))
		op=1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,0,0)
end
function c888000016.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local mg=Duel.GetMatchingGroup(c888000016.filter1,tp,LOCATION_REMOVED,0,nil,e)
		local sg=Duel.GetMatchingGroup(c888000016.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
		if sg:GetCount()>0 then
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			local code=tc:GetCode()
			local mat=Duel.SelectFusionMaterial(tp,tc,mg)
			local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
			local tc=fg:GetFirst()
			while tc do
				tc:SetMaterial(mat)
				tc=fg:GetNext()
			end
		Duel.SendtoHand(mat,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mat)
		end
	end
	if e:GetLabel()==1 then
		local g=Duel.SelectMatchingCard(tp,c888000016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local mg=Duel.GetMatchingGroup(c888000016.filter1,tp,LOCATION_REMOVED,0,nil,e)
		local sg=Duel.GetMatchingGroup(c888000016.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
		if sg:GetCount()>0 then
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			local code=tc:GetCode()
			local mat=Duel.SelectFusionMaterial(tp,tc,mg)
			local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
			local tc=fg:GetFirst()
			while tc do
				tc:SetMaterial(mat)
				tc=fg:GetNext()
			end
			Duel.SendtoHand(mat,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mat)
			local g=Duel.SelectMatchingCard(tp,c888000016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
