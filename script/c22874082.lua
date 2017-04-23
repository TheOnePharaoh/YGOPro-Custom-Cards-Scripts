--B.M.I. Headphone Compound Unit "Trigger Happy"
function c22874082.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c22874082.filter)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c22874082.atkval)
	c:RegisterEffect(e2)
	--equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c22874082.eqlimit)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(c22874082.thcon)
	e4:SetTarget(c22874082.thtg)
	e4:SetOperation(c22874082.thop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22874076,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c22874082.speccon)
	e5:SetTarget(c22874082.spectg)
	e5:SetOperation(c22874082.specop)
	c:RegisterEffect(e5)
end
function c22874082.eqlimit(e,c)
	return c:IsType(TYPE_XYZ)
end
function c22874082.filter(c)
	return c:IsType(TYPE_XYZ)
end
function c22874082.atkval(e,c)
	return c:GetRank()*200
end
function c22874082.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ec=e:GetHandler():GetEquipTarget()
	local at=Duel.GetAttacker()
	return tc==ec and at and not at:IsRace(RACE_MACHINE) and at:GetAttack()>ec:GetAttack()
end
function c22874082.thfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c22874082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22874082.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22874082.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22874082.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local tc=Duel.GetAttacker()
		if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsAttackable() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetValue(1)
			e1:SetCondition(c22874082.damcon)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetLabelObject(tc)
			c:GetEquipTarget():RegisterEffect(e1,true)
		end
	end
end
function c22874082.damcon(e)
	return e:GetLabelObject()==Duel.GetAttacker()
end
function c22874082.speccon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
end
function c22874082.specfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsAttackBelow(1500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22874082.spectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22874082.specfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22874082.specop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22874082.specfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e2:SetValue(c22874082.synlimit)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c22874082.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x0dac404)
end
