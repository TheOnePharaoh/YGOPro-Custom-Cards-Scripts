--Infection Spreading
function c66452463.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c66452463.condition)
	e1:SetTarget(c66452463.target)
	e1:SetOperation(c66452463.activate)
	c:RegisterEffect(e1)
end
function c66452463.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return eg:GetCount()==1 and ec:GetPreviousControler()==tp and ec:IsSetCard(0x0dac405)
		and bit.band(ec:GetPreviousRaceOnField(),0x0dac405)~=0
		and ec==Duel.GetAttackTarget() and ec:IsLocation(LOCATION_GRAVE) and ec:IsReason(REASON_BATTLE)
end
function c66452463.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst():GetReasonCard()
	if chk==0 then return tc:IsControler(1-tp) and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c66452463.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_MACHINE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
